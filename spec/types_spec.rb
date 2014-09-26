# encoding: utf-8

require 'spec_helper'

describe 'Settings kind' do
  it 'html' do
    expect(Settings.get(:email, kind: 'html', default: 'test@example.com').to_s).to eq 'test@example.com'
  end

  it 'integer' do
    expect(Settings.get(:testint, kind: 'integer').value).to eq 0
    expect(Settings.get(:testint, default: 5, kind: 'integer').value).to eq 0
    expect(Settings.get(:testint2, default: 5, kind: 'integer').value).to eq 5
    expect(Settings.testint2).to eq 5
  end

  it 'yaml' do
    Settings.set(:data, '[one, two, three]', kind: 'yaml')
    expect(Settings.get(:data).raw).to eq '[one, two, three]'
    expect(Settings.data).to eq ['one', 'two', 'three']
  end

  it 'phone' do
    Settings.set(:tphone, '906 111 11 11', kind: 'phone')
    expect(Settings.get(:tphone).val.class.name).to eq 'RussianPhone::Number'
    expect(Settings.tphone.class.name).to eq 'RussianPhone::Number'
    expect(Settings.tphone).to eq '906 111 11 11'
    expect(Settings.get(:tphone).phone_kind?).to be_truthy
    expect(Settings.get(:tphone).val.city).to eq '906'
    expect(Settings.get(:tphone).val.formatted_subscriber).to eq '111-11-11'
  end

  it 'supports phones kind' do
    Settings.set(:tphone, ['906 111 11 11', '907 111 11 11'] * "\n", kind: 'phones')
    expect(Settings.get(:tphone).val.class.name).to eq 'Array'
    expect(Settings.tphone.class.name).to eq 'Array'
    expect(Settings.get(:tphone).val.first.class.name).to eq 'RussianPhone::Number'
    expect(Settings.tphone.first.class.name).to eq 'RussianPhone::Number'
    expect(Settings.tphone.first).to eq '906 111 11 11'
    expect(Settings.get(:tphone).phones_kind?).to be_truthy
    expect(Settings.get(:tphone).val.first.city).to eq '906'
    expect(Settings.get(:tphone).val.last.city).to eq '907'
    expect(Settings.get(:tphone).val.first.formatted_subscriber).to eq '111-11-11'
  end

  it 'defaults for phone' do
    Settings.dphone(kind: 'phone')
    expect(Settings.get(:dphone).phone_kind?).to be_truthy
    expect(Settings.dphone.formatted_area).to eq ''
    expect(Settings.dphone.formatted_subscriber).to eq ''
  end

  it 'email validates' do
    Settings.eml(kind: 'email')
    expect(Settings.get(:eml).email_kind?).to be_truthy
    expect { Settings.eml = '1' }.to raise_error
    Settings.eml = 'test@example.com'
    expect(Settings.eml).to eq 'test@example.com'
  end

  it 'url processing' do
    Settings.url(kind: 'url')
    expect(Settings.get(:url).url_kind?).to be_truthy
    expect(Settings.get(:url).color_kind?).to be_falsey
    Settings.url = 'test.ru'
    expect(Settings.url).to eq 'http://test.ru'
  end

  it 'color' do
    Settings.col(kind: 'color')
    expect(Settings.get(:col).color_kind?).to be_truthy
    expect { Settings.col = 'test'}.to raise_error
    Settings.col = 'ffffff'
    expect(Settings.col).to eq 'ffffff'
    expect {
      Settings.col = 'zzzzzz'
    }.to raise_error
  end
end