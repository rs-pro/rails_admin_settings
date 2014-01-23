# encoding: utf-8

require 'spec_helper'

describe 'Settings types' do
  it 'boolean' do
    Settings.get(:testbool, type: 'boolean').value.should be_false
    Settings.get(:testbool, default: true, type: 'boolean').value.should be_false
    Settings.get(:testbool2, default: true, type: 'boolean').value.should be_true
    Settings.testbool2.should be_true
    Settings.set(:testbool3, true, type: 'boolean')
    Settings.testbool3.should be_true
  end

  it 'html' do
    Settings.get(:email, type: 'html', default: 'test@example.com').to_s.should eq 'test@example.com'
  end

  it 'integer' do
    Settings.get(:testint, type: 'integer').value.should eq 0
    Settings.get(:testint, default: 5, type: 'integer').value.should eq 0
    Settings.get(:testint2, default: 5, type: 'integer').value.should eq 5
    Settings.testint2.should eq 5
  end

  it 'yaml' do
    Settings.set(:data, '[one, two, three]', type: 'yaml')
    Settings.get(:data).raw.should eq '[one, two, three]'
    Settings.data.should eq ['one', 'two', 'three']
  end

  it 'phone' do
    Settings.set(:tphone, '906 111 11 11', type: 'phone')
    Settings.get(:tphone).val.class.name.should eq 'RussianPhone::Number'
    Settings.tphone.class.name.should eq 'RussianPhone::Number'
    Settings.tphone.should eq '906 111 11 11'
    Settings.get(:tphone).phone_type?.should be_true
    Settings.get(:tphone).val.city.should eq '906'
    Settings.get(:tphone).val.formatted_subscriber.should eq '111-11-11'
  end

  it 'supports phones type' do
    Settings.set(:tphone, ['906 111 11 11', '907 111 11 11'] * "\n", type: 'phones')
    Settings.get(:tphone).val.class.name.should eq 'Array'
    Settings.tphone.class.name.should eq 'Array'
    Settings.get(:tphone).val.first.class.name.should eq 'RussianPhone::Number'
    Settings.tphone.first.class.name.should eq 'RussianPhone::Number'
    Settings.tphone.first.should eq '906 111 11 11'
    Settings.get(:tphone).phones_type?.should be_true
    Settings.get(:tphone).val.first.city.should eq '906'
    Settings.get(:tphone).val.last.city.should eq '907'
    Settings.get(:tphone).val.first.formatted_subscriber.should eq '111-11-11'
  end

  it 'defaults for phone' do
    Settings.dphone(type: 'phone')
    Settings.get(:dphone).phone_type?.should be_true
    Settings.dphone.formatted_area.should eq ''
    Settings.dphone.formatted_subscriber.should eq ''
  end

  it 'email validates' do
    Settings.eml(type: 'email')
    Settings.get(:eml).email_type?.should be_true
    expect { Settings.eml = '1' }.to raise_error
    Settings.eml = 'test@example.com'
    Settings.eml.should eq 'test@example.com'
  end

  it 'url processing' do
    Settings.url(type: 'url')
    Settings.get(:url).url_type?.should be_true
    Settings.get(:url).color_type?.should be_false
    Settings.url = 'test.ru'
    Settings.url.should eq 'http://test.ru'
  end

  it 'color' do
    Settings.col(type: 'color')
    Settings.get(:col).color_type?.should be_true
    expect { Settings.col = 'test'}.to raise_error
    Settings.col = 'ffffff'
    Settings.col.should eq 'ffffff'
    expect {
      Settings.col = 'zzzzzz'
    }.to raise_error
  end
end