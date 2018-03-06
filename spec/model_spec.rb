# encoding: utf-8

require 'spec_helper'

describe RailsAdminSettings::Setting do
  it { is_expected.to have_fields(:enabled, :key, :kind, :raw) }

  it "correctly return content when enabled" do
    setting = FactoryBot.create(:setting)
    expect(setting.to_s).to eq "Контент 1"
  end

  it "return empty string when disabled" do
    setting = FactoryBot.create(:setting, enabled: false)
    expect(setting.to_s).to eq ""
  end

  it "correctly process {{year}}" do
    setting = FactoryBot.create(:setting, raw: '&copy; {{year}} company')
    expect(setting.val).to eq "&copy; #{Time.now.strftime('%Y')} company"
  end

  it "correctly process {{year|2010}}" do
    setting = FactoryBot.create(:setting, raw: '&copy; {{year|2010}} company')
    expect(setting.val).to eq "&copy; 2010-#{Time.now.strftime('%Y')} company"
  end

  it "correctly process {{year|current_year}}" do
    setting = FactoryBot.create(:setting, raw: '&copy; {{year|' + Time.now.strftime('%Y') + '}} company')
    expect(setting.val).to eq "&copy; #{Time.now.strftime('%Y')} company"
    expect(setting.val.class.name).not_to eq "ActiveSupport::SafeBuffer"
  end

  it 'return html_safe string when in html mode' do
    setting = FactoryBot.create(:setting, raw: '&copy; {{year}} company', kind: 'html')
    expect(setting.val).to eq "&copy; #{Time.now.strftime('%Y')} company"
    expect(setting.val.class.name).to eq "ActiveSupport::SafeBuffer"
  end

  it 'sanitize html when in sanitized mode' do
    setting = FactoryBot.create(:setting, raw: '&copy; {{year}} company <a href="javascript:alert()">test</a>', kind: 'sanitized')
    expect(setting.val).to eq "© #{Time.now.strftime('%Y')} company <a>test</a>"
    expect(setting.val.class.name).to eq "ActiveSupport::SafeBuffer"
  end

  it 'sanitize html when in sanitize mode' do
    if defined?(Rails)
      setting = FactoryBot.create(:setting, raw: '&copy; {{year}} company <a href="javascript:alert()">test</a>', kind: 'sanitize')
      expect(setting.val).to eq "© #{Time.now.strftime('%Y')} company <a>test</a>"
      expect(setting.val.class.name).to eq "ActiveSupport::SafeBuffer"
    else
      expect {
        FactoryBot.create(:setting, raw: '&copy; {{year}} company <a href="javascript:alert()">test</a>', kind: 'sanitize')
      }.to raise_error(RailsAdminSettings::NoRailsError)
    end
  end

  it 'sanitize html when in sanitize_code mode' do
    if defined?(Rails)
      setting = FactoryBot.create(:setting, raw: '&copy; {{year}} company <a href="javascript:alert()">test</a>', kind: 'sanitize_code')
      expect(setting.val).to eq "© #{Time.now.strftime('%Y')} company <a>test</a>"
      expect(setting.val.class.name).to eq "ActiveSupport::SafeBuffer"
    else
      expect {
        FactoryBot.create(:setting, raw: '&copy; {{year}} company <a href="javascript:alert()">test</a>', kind: 'sanitize_code')
      }.to raise_error(RailsAdminSettings::NoRailsError)
    end
  end

  it 'remove html when in strip_tags mode' do
    if defined?(Rails)
      setting = FactoryBot.create(:setting, raw: '&copy; {{year}} company <a href="javascript:alert()">test</a>', kind: 'strip_tags')
      expect(setting.val).to eq "© #{Time.now.strftime('%Y')} company test"
      expect(setting.val.class.name).to eq "ActiveSupport::SafeBuffer"
    else
      expect {
        FactoryBot.create(:setting, raw: '&copy; {{year}} company <a href="javascript:alert()">test</a>', kind: 'strip_tags')
      }.to raise_error(RailsAdminSettings::NoRailsError)
    end
  end

  it 'formats text and cleans html in simple_format mode' do
    if defined?(Rails)
      setting = FactoryBot.create(:setting, raw: "&copy; {{year}}\n\ncompany <a href='javascript:alert()'>test</a>", kind: 'simple_format')
      expect(setting.val).to eq "<p>© #{Time.now.strftime('%Y')}</p>\n\n<p>company <a>test</a></p>"
      expect(setting.val.class.name).to eq "ActiveSupport::SafeBuffer"
    else
      expect {
        FactoryBot.create(:setting, raw: "&copy; {{year}}\n\ncompany <a href='javascript:alert()'>test</a>", kind: 'simple_format')
      }.to raise_error(RailsAdminSettings::NoRailsError)
    end
  end

  it 'formats text and DOESNT html in simple_format_raw mode' do
    if defined?(Rails)
      setting = FactoryBot.create(:setting, raw: "&copy; {{year}}\n\ncompany <a href='javascript:alert()'>test</a>", kind: 'simple_format_raw')
      expect(setting.val).to eq "<p>&copy; #{Time.now.strftime('%Y')}</p>\n\n<p>company <a href='javascript:alert()'>test</a></p>"
      expect(setting.val.class.name).to eq "ActiveSupport::SafeBuffer"
    else
      expect {
        FactoryBot.create(:setting, raw: "&copy; {{year}}\n\ncompany <a href='javascript:alert()'>test</a>", kind: 'simple_format_raw')
      }.to raise_error(RailsAdminSettings::NoRailsError)
    end
  end
end
