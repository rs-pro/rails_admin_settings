# encoding: utf-8

require 'spec_helper'

# this tests check how well rails_admin_settings handles settings disappearing from DB during execution
# real usage: app specs with database_cleaner enabled
describe 'Database trickery' do

  it "should handle settings disappearing from DB" do
    email = "my@mail.ru"
    email2 = "my2@mail.ru"
    Settings.email = email
    expect(Settings.email).to eq(email)
    RailsAdminSettings::Setting.destroy_all
    # settings are still cached
    expect(Settings.email).to eq(email)

    Settings.email = email2
    expect(Settings.email).to eq(email2)
  end

  it "should handle settings appearing in DB when settings are loaded" do
    expect(Settings.tst2).to eq('')
    RailsAdminSettings::Setting.create!(key: 'tst', raw: 'tst')
    # settings are still cached, but when we try to create a setting it sees updated value in DB
    expect(Settings.tst).to eq('tst')
  end

  it "should handle settings appearing in DB when settings are not loaded" do
    RailsAdminSettings::Setting.create(key: 'tst', raw: 'tst')
    Settings.tst = 'str'
    expect(Settings.tst).to eq('str')
  end

  it "#destroy_all!" do
    Settings.tst = 'str'
    Settings.destroy_all!
    expect(Settings.tst).to eq('')
  end

  it "#destroy!" do
    Settings.tst = 'str'
    Settings.tst2 = 'str2'
    Settings.destroy!(:tst)
    expect(Settings.tst).to eq('')
    expect(Settings.tst2).to eq('str2')
  end
end
