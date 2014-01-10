# encoding: utf-8

require 'spec_helper'

describe 'Settings' do
  it "should works as RailsSettings" do
    Settings.destroy_all!

    email = "my@mail.ru"
    Settings.email = email
    Settings.email.should == email
  end

  it '#get should return new setting when setting does not exist' do
    t = Settings.get(:test)
    t.class.name.should eq 'RailsAdminSettings::Setting'
    t.persisted?.should eq true
    t.value.should eq ''
  end

  it '#name should return empty string when setting does not exist' do
    Settings.test.should eq ''
    Settings['test'].value.should eq ''
  end

  it "should save default" do
    Settings.destroy_all!

    email = "my@mail.ru"
    email2 = "my2@mail.ru"
    Settings.save_default(:email, email)
    Settings.email.should == email
    Settings.email = email2
    Settings.email.should == email2
    Settings.save_default(:email, email)
    Settings.email.should == email2
  end

  it 'should properly unload' do
    Settings.load!
    Settings.loaded.should eq true
    Settings.unload!
    Settings.loaded.should eq false
  end

  it 'should work with type and default' do
    Settings.phone(type: 'phone', default: '906 111 11 11').should eq '+7 (906) 111-11-11'
    Settings.phone = '906 222 22 22'
    Settings.phone(type: 'phone', default: '906 111 11 11').should eq '+7 (906) 222-22-22'
  end
  
  it 'should properly store settings to DB' do
    Settings.unload!
    Settings.loaded.should eq false
    Settings.temp = '123'
    Settings.loaded.should eq true
    Settings.unload!
    Settings.loaded.should eq false
    Settings.temp.should eq '123'
    Settings.loaded.should eq true
  end

  it 'should support yaml type' do
    Settings.tdata(type: 'yaml')
    Settings.tdata = ['one', 'two', 'three']
    YAML.safe_load(Settings.get(:tdata).raw).should eq ['one', 'two', 'three']
    Settings.tdata.should eq ['one', 'two', 'three']
  end

  it '#enabled? sets defaults' do
    Settings.enabled?(:phone, type: 'phone').should eq true
    Settings.get(:phone).type.should eq 'phone'
  end

end
