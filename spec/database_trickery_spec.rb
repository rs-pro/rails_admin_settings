# encoding: utf-8

require 'spec_helper'

# this tests check how well rails_admin_settings handles settings disappearing from DB during execution
# real usage: app specs with database_cleaner enabled
describe Settings do

  it "should handle settings disappearing from DB" do
    email = "my@mail.ru"
    email2 = "my2@mail.ru"
    Settings.email = email
    Settings.email.should == email
    RailsAdminSettings::Setting.destroy_all
    # settings are still cached
    Settings.email.should == email

    Settings.email = email2
    Settings.email.should == email2
  end

  it "should handle settings appearing from DB" do
    Settings.tst2.should == ''
    RailsAdminSettings::Setting.create(key: 'tst', raw: 'tst')
    # settings are still cached, but when we try to create a setting it sees updated value in DB
    Settings.tst.should == 'tst'
  end

  it "should handle settings appearing in DB" do
    RailsAdminSettings::Setting.create(key: 'tst', raw: 'tst')

    Settings.tst = 'str'
    Settings.tst.should == 'str'
  end

  it "#destroy_all!" do
    Settings.tst = 'str'
    expect { Settings.destroy_all }.to raise_exception
    Settings.destroy_all!
    Settings.tst.should == ''
  end
  it "#destroy!" do
    Settings.tst = 'str'
    Settings.tst2 = 'str2'
    expect { Settings.destroy(:tst) }.to raise_exception
    Settings.destroy!(:tst)
    Settings.tst.should == ''
    Settings.tst2.should == 'str2'
  end
end
