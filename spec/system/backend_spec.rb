require 'system_helper'

RSpec.describe 'ActiveRecord settings backend' do
  it 'updates existing values with the modern ActiveRecord API' do
    Settings.set(:headline, 'First')
    Settings.set(:headline, 'Second')
    Settings.unload!

    expect(Settings.headline).to eq('Second')
    expect(RailsAdminSettings::Setting.where(key: 'headline').count).to eq(1)
    expect(Settings.get(:headline)).to be_enabled
  end

  it 'sanitizes HTML with the current Rails sanitizer' do
    setting = Settings.set(:intro, '<a href="javascript:alert(1)">Hello</a>', kind: 'sanitize')

    expect(setting.raw).to eq('<a>Hello</a>')
    expect(Settings.intro).to eq('<a>Hello</a>')
  end

  it 'keeps namespaced settings separate' do
    Settings.set(:headline, 'Main')
    Settings.ns('footer').set(:headline, 'Footer')
    Settings.unload!

    expect(Settings.headline).to eq('Main')
    expect(Settings.ns('footer').headline).to eq('Footer')
  end
end
