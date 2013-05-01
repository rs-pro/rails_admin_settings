# encoding: utf-8

require 'spec_helper'

describe 'Settings label' do
  
  it "should have label" do
    label = "E-Mail"
    Settings.email(label: label, default: "my@mail.ru")
    Settings.label(:email).should == label
  end

  it "should properly set label as key if blank" do
    Settings.email(default: "my@mail.ru")
    Settings.label(:email).should == 'email'
  end

end
