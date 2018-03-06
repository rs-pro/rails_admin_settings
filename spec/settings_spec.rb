# encoding: utf-8

require 'spec_helper'

describe 'Settings' do
  it "should works as RailsSettings" do
    Settings.destroy_all!

    email = "my@mail.ru"
    Settings.email = email
    expect(Settings.email).to eq(email)
  end

  it '#get should return new setting when setting does not exist' do
    t = Settings.get(:test)
    expect(t.class.name).to eq 'RailsAdminSettings::Setting'
    expect(t.persisted?).to eq true
    expect(t.value).to eq ''
  end

  it '#name should return empty string when setting does not exist' do
    expect(Settings.test).to eq ''
    expect(Settings['test'].value).to eq ''
  end

  it "should save default" do
    Settings.destroy_all!

    email = "my@mail.ru"
    email2 = "my2@mail.ru"
    Settings.save_default(:email, email)
    expect(Settings.email).to eq(email)
    Settings.email = email2
    expect(Settings.email).to eq(email2)
    Settings.save_default(:email, email)
    expect(Settings.email).to eq(email2)
  end

  it 'should properly unload' do
    Settings.load!
    expect(Settings.loaded).to eq true
    Settings.unload!
    expect(Settings.loaded).to eq false
  end

  it 'should work with kind and default' do
    expect(Settings.phone(kind: 'phone', default: '906 111 11 11')).to eq '+7 (906) 111-11-11'
    Settings.phone = '906 222 22 22'
    expect(Settings.phone(kind: 'phone', default: '906 111 11 11')).to eq '+7 (906) 222-22-22'
  end

  it 'should properly store settings to DB' do
    Settings.unload!
    expect(Settings.loaded).to eq false
    Settings.temp = '123'
    expect(Settings.loaded).to eq true
    Settings.unload!
    expect(Settings.loaded).to eq false
    expect(Settings.temp).to eq '123'
    expect(Settings.loaded).to eq true
  end

  it 'should support yaml kind' do
    Settings.tdata(kind: 'yaml')
    Settings.tdata = ['one', 'two', 'three']
    expect(YAML.safe_load(Settings.get(:tdata).raw)).to eq ['one', 'two', 'three']
    expect(Settings.tdata).to eq ['one', 'two', 'three']
  end

  it '#enabled? sets defaults' do
    expect(Settings.enabled?(:phone, kind: 'phone')).to eq true
    expect(Settings.get(:phone).kind).to eq 'phone'
  end

end
