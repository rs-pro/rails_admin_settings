require 'rails_admin_helper'

RSpec.describe 'RailsAdmin settings demo', type: :feature, js: true do
  let!(:setting) { Settings.set(:site_title, 'Original', label: 'Site title') }

  it 'lists and edits an existing setting' do
    visit '/rails_admin/rails_admin_settings~setting'
    expect(page).to have_content('Site title')

    visit "/rails_admin/rails_admin_settings~setting/#{setting.id}/edit"
    fill_in 'Value', with: 'Updated in RailsAdmin'
    click_button 'Save'

    expect(page).to have_content('Updated in RailsAdmin')
    expect(Settings.site_title).to eq('Updated in RailsAdmin')
  end

  it 'shows the disabled state after updating an existing setting' do
    setting.update!(enabled: false)
    visit "/rails_admin/rails_admin_settings~setting/#{setting.id}/edit"

    expect(page).to have_checked_field('rails_admin_settings_setting_enabled_0')
    expect(Settings.site_title).to eq('')
  end
end
