# encoding: utf-8

require 'spec_helper'

describe 'Settings advanced usage' do
  it 'support html type' do
    Settings.get(:email, type: 'html', default: 'test@example.com').to_s.should eq 'test@example.com'
  end

  it 'support integer type' do
    Settings.get(:testint, type: 'integer').value.should eq 0
    Settings.get(:testint, default: 5, type: 'integer').value.should eq 0
    Settings.get(:testint2, default: 5, type: 'integer').value.should eq 5
    Settings.testint2.should eq 5
  end

  it 'supports yaml type' do
    Settings.set(:data, '[one, two, three]', type: 'yaml')
    Settings.get(:data).raw.should eq '[one, two, three]'
    Settings.data.should eq ['one', 'two', 'three']
  end

  it 'supports phone type' do
    Settings.set(:tphone, '906 111 11 11', type: 'phone')
    Settings.get(:tphone).val.class.name.should eq 'RussianPhone::Number'
    Settings.tphone.class.name.should eq 'RussianPhone::Number'
    Settings.tphone.should eq '906 111 11 11'
    Settings.get(:tphone).phone_type?.should be_true
    Settings.get(:tphone).val.city.should eq '906'
    Settings.get(:tphone).val.formatted_subscriber.should eq '111-11-11'
  end

  it 'sets defaults for phone type' do
    Settings.dphone(type: 'phone')
    Settings.get(:dphone).phone_type?.should be_true
    Settings.dphone.formatted_area.should eq ''
    Settings.dphone.formatted_subscriber.should eq ''
  end

  it 'validates emails with email type' do
    Settings.eml(type: 'email')
    Settings.get(:eml).email_type?.should be_true
    expect { Settings.eml = '1' }.to raise_error
    Settings.eml = 'test@example.com'
    Settings.eml.should eq 'test@example.com'
  end

  it 'processes urls with url type' do
    Settings.url(type: 'url')
    Settings.get(:url).url_type?.should be_true
    Settings.get(:url).color_type?.should be_false
    Settings.url = 'test.ru'
    Settings.url.should eq 'http://test.ru'
  end

  it 'supports color type' do
    Settings.col(type: 'color')
    Settings.get(:col).color_type?.should be_true
    expect { Settings.col = 'test'}.to raise_error
    Settings.col = 'ffffff'
    Settings.col.should eq 'ffffff'
  end
end