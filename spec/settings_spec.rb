# encoding: utf-8

require 'spec_helper'

describe Settings do

  it "should works as RailsSettings" do
    Settings.destroy_all!

    email = "my@mail.ru"
    Settings.email = email
    Settings.email.should == email
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
    Settings.class_eval { cattr_accessor :loaded }
    Settings.load!
    Settings.loaded.should eq true
    Settings.unload!
    Settings.loaded.should eq false
  end

  it 'should properly store settings to DB' do
    Settings.class_eval { cattr_accessor :loaded }
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
