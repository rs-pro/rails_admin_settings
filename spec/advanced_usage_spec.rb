# encoding: utf-8

require 'spec_helper'

describe 'Settings advanced usage' do
  it 'with defaults' do
    s = Settings.email(default: 'test@example.com')
    s.should eq 'test@example.com'
    Settings.get(:email).to_s.should eq 'test@example.com'
  end
end