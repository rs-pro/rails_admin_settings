# encoding: utf-8

require 'spec_helper'

describe RailsAdminSettings::Setting do
  it { should have_fields(:enabled, :code, :mode, :content_1, :content_2) }

  it "should correctly return content when enabled" do
    setting = FactoryGirl.create(:setting)
    setting.c1.should eq "Контент 1"
    setting.to_s.should eq "Контент 1"
    setting.c2.should eq "Контент 2"
  end

  it "should return empty string when disabled" do
    setting = FactoryGirl.create(:setting, enabled: false)

    setting.c1.should eq ""
    setting.to_s.should eq ""
    setting.c2.should eq ""
  end

  it "should correctly process {{year}}" do
    setting = FactoryGirl.create(:setting, content_1: '&copy; {{year}} company')

    setting.c1.should eq "&copy; #{Time.now.strftime('%Y')} company"
  end

  it "should correctly process {{year|2010}}" do
    setting = FactoryGirl.create(:setting, content_1: '&copy; {{year|2010}} company')

    setting.c1.should eq "&copy; 2010-#{Time.now.strftime('%Y')} company"
  end

  it "should correctly process {{year|current_year}}" do
    setting = FactoryGirl.create(:setting, content_1: "&copy; {{year|#{Time.now.strftime('%Y')}}} company")

    setting.c1.should eq "&copy; #{Time.now.strftime('%Y')} company"
  end
end