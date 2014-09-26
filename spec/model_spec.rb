# encoding: utf-8

require 'spec_helper'

describe RailsAdminSettings::Setting do
  it { is_expected.to have_fields(:enabled, :key, :kind, :raw) }

  it "correctly return content when enabled" do
    setting = FactoryGirl.create(:setting)
    expect(setting.to_s).to eq "Контент 1"
  end

  it "return empty string when disabled" do
    setting = FactoryGirl.create(:setting, enabled: false)
    expect(setting.to_s).to eq ""
  end

  it "correctly process {{year}}" do
    setting = FactoryGirl.create(:setting, raw: '&copy; {{year}} company')
    expect(setting.val).to eq "&copy; #{Time.now.strftime('%Y')} company"
  end

  it "correctly process {{year|2010}}" do
    setting = FactoryGirl.create(:setting, raw: '&copy; {{year|2010}} company')
    expect(setting.val).to eq "&copy; 2010-#{Time.now.strftime('%Y')} company"
  end

  it "correctly process {{year|current_year}}" do
    setting = FactoryGirl.create(:setting, raw: '&copy; {{year|' + Time.now.strftime('%Y') + '}} company')
    expect(setting.val).to eq "&copy; #{Time.now.strftime('%Y')} company"
    expect(setting.val.class.name).not_to eq "ActiveSupport::SafeBuffer"
  end

  it 'return html_safe string when in html mode' do
    setting = FactoryGirl.create(:setting, raw: '&copy; {{year}} company', kind: 'html')
    expect(setting.val).to eq "&copy; #{Time.now.strftime('%Y')} company"
    expect(setting.val.class.name).to eq "ActiveSupport::SafeBuffer"
  end

  it 'sanitize html when in sanitized mode' do
    setting = FactoryGirl.create(:setting, raw: '&copy; {{year}} company <a href="javascript:alert()">test</a>', kind: 'sanitized')
    expect(setting.val).to eq "© #{Time.now.strftime('%Y')} company <a>test</a>"
    expect(setting.val.class.name).to eq "ActiveSupport::SafeBuffer"
  end
end