# encoding: utf-8

require 'spec_helper'

describe 'Settings advanced usage' do
  it 'with defaults' do
    s = Settings.email(default: 'test@example.com')
    s.should eq 'test@example.com'
    Settings.get(:email).to_s.should eq 'test@example.com'
  end

  it 'support html mode' do
    Settings.get(:email, type: 'html').to_s.should eq 'test@example.com'
  end

  it 'support integer mode' do
    Settings.get(:testint, type: 'integer').value.should eq 0
    Settings.get(:testint, default: 5, type: 'integer').value.should eq 0
    Settings.get(:testint2, default: 5, type: 'integer').value.should eq 5
    Settings.testint2.should eq 5
  end

  it 'support yaml mode' do
    Settings.get(:test_yml, type: 'yaml').value.should be_nil
    Settings.get(:test_yml_2, default: '[t1, t2, t3]', type: 'yaml').value.should eq ['t1', 't2', 't3']
    Settings.test_yml_2.should eq ['t1', 't2', 't3']
  end

  it 'should have sensible defaults' do
    s = Settings.get(:test_sett)
    s.should_not be_nil
    s.type.should eq 'string'
    s.raw.should eq ''
    s.value.should eq ''
  end

  it 'should support yaml type' do
    Settings.set(:data, '[one, two, three]', type: 'yaml')
    Settings.get(:data).raw.should eq '[one, two, three]'
    Settings.data.should eq ['one', 'two', 'three']
  end

  it 'should support phone type' do
    Settings.set(:tphone, '906 111 11 11', type: 'phone')
    Settings.get(:tphone).val.class.name.should eq 'RussianPhone::Number'
    Settings.tphone.class.name.should eq 'RussianPhone::Number'
    Settings.tphone.should eq '906 111 11 11'

    Settings.get(:tphone).val.city.should eq '906'
    Settings.get(:tphone).val.formatted_subscriber.should eq '111-11-11'
  end

  it 'should set defaults for phone type' do
    Settings.dphone(type: 'phone')

    Settings.dphone.formatted_area.should eq ''
    Settings.dphone.formatted_subscriber.should eq ''
  end

  it 'should validate emails with email type' do
    Settings.eml(type: 'email')
    expect { Settings.eml = '1' }.to raise_error
    Settings.eml = 'test@example.com'
    Settings.eml.should eq 'test@example.com'
  end
end