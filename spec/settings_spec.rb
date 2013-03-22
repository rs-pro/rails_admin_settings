# encoding: utf-8

require 'spec_helper'

describe Settings do

  it "should works as RailsSettings" do
    email = "my@mail.ru"
    Settings.email = email
    Settings.email.should == email
  end

  it "should save default" do
    email = "my@mail.ru"
    email2 = "my2@mail.ru"
    Settings.save_default(:email, email)
    Settings.email.should == email
    Settings.email = email2
    Settings.email.should == email2
    Settings.save_default(:email, email)
    Settings.email.should == email2
  end

  context 'advanced usage' do
    it 'should properly support dualstring' do
      Settings.phone(mode: 'two').enabled?
    end
  end
end
