require 'system_helper'

RSpec.describe 'Settings administration', type: :feature, js: true do
  let!(:setting) { Settings.set(:site_title, 'Original', label: 'Site title') }

  it 'lists settings in ActiveAdmin and links to their edit form' do
    visit '/admin/rails_admin_settings_settings'
    expect(page).to have_content('Site title')
    click_link 'Edit', match: :first
    expect(page).to have_field('Value', with: 'Original')
  end

  it 'loads its importmap JavaScript for theme switching and filter operators' do
    visit '/admin/rails_admin_settings_settings'
    original_theme = page.evaluate_script("document.documentElement.classList.contains('dark')")
    find('button.dark-mode-toggle').click
    expect(page.evaluate_script("document.documentElement.classList.contains('dark')")).to eq(!original_theme)

    page.find('#q_ns_input select').select('Equals')
    expect(page.evaluate_script("document.querySelector('#q_ns').name")).to eq('q[ns_eq]')
  end

  it 'edits the same setting through ActiveAdmin and reads it through Settings' do
    visit "/admin/rails_admin_settings_settings/#{setting.id}/edit"
    fill_in 'Value', with: 'Updated in ActiveAdmin'
    click_button 'Update Setting'

    expect(page).to have_content('Updated in ActiveAdmin')
    expect(Settings.site_title).to eq('Updated in ActiveAdmin')
  end

  it 'disables a setting in ActiveAdmin' do
    visit "/admin/rails_admin_settings_settings/#{setting.id}/edit"
    uncheck 'Enabled'
    click_button 'Update Setting'

    expect(RailsAdminSettings::Setting.find(setting.id)).to be_disabled
    expect(Settings.site_title).to eq('')

  end

  it 'preserves the namespace and key while editing in ActiveAdmin' do
    other = Settings.ns('footer').set(:site_title, 'Footer')
    visit "/admin/rails_admin_settings_settings/#{other.id}/edit"
    fill_in 'Value', with: 'Changed footer'
    click_button 'Update Setting'

    expect(Settings.ns('footer').site_title).to eq('Changed footer')
    expect(Settings.site_title).to eq('Original')
  end

  it 'shows edited settings on the public demo page' do
    visit '/'
    expect(page).to have_content('Original')

    visit "/admin/rails_admin_settings_settings/#{setting.id}/edit"
    fill_in 'Value', with: 'Changed in ActiveAdmin'
    click_button 'Update Setting'
    visit '/'
    expect(page).to have_css('h1', text: 'Changed in ActiveAdmin')

  end
end
