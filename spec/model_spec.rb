# encoding: utf-8

require 'spec_helper'

describe RailsAdminSettings::Setting do
  it { should have_fields(:enabled, :key, :type, :raw) }

  it "correctly return content when enabled" do
    setting = FactoryGirl.create(:setting)
    setting.to_s.should eq "Контент 1"
  end

  it "return empty string when disabled" do
    setting = FactoryGirl.create(:setting, enabled: false)
    setting.to_s.should eq ""
  end

  it "correctly process {{year}}" do
    setting = FactoryGirl.create(:setting, raw: '&copy; {{year}} company')
    setting.val.should eq "&copy; #{Time.now.strftime('%Y')} company"
  end

  it "correctly process {{year|2010}}" do
    setting = FactoryGirl.create(:setting, raw: '&copy; {{year|2010}} company')
    setting.val.should eq "&copy; 2010-#{Time.now.strftime('%Y')} company"
  end

  it "correctly process {{year|current_year}}" do
    setting = FactoryGirl.create(:setting, raw: '&copy; {{year|' + Time.now.strftime('%Y') + '}} company')
    setting.val.should eq "&copy; #{Time.now.strftime('%Y')} company"
    setting.val.class.name.should_not eq "ActiveSupport::SafeBuffer"
  end

  it 'return html_safe string when in html mode' do
    setting = FactoryGirl.create(:setting, raw: '&copy; {{year}} company', type: 'html')
    setting.val.should eq "&copy; #{Time.now.strftime('%Y')} company"
    setting.val.class.name.should eq "ActiveSupport::SafeBuffer"
  end

  it 'sanitize html when in sanitized mode' do
    setting = FactoryGirl.create(:setting, raw: '&copy; {{year}} company <a href="javascript:alert()">test</a>', type: 'sanitized')
    setting.val.should eq "© #{Time.now.strftime('%Y')} company <a>test</a>"
    setting.val.class.name.should eq "ActiveSupport::SafeBuffer"
  end
end