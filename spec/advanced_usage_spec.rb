# encoding: utf-8

require 'spec_helper'

describe 'Settings advanced usage' do
  it 'support creating settings with defaults' do
    s = Settings.email(default: 'test@example.com')
    s.should eq 'test@example.com'
    Settings.get(:email).c1.should eq 'test@example.com'
  end

  it 'support html mode' do
    Settings.get(:email, mode: 'html').c1.should eq 'test@example.com'
  end

  it 'support integer mode' do
    Settings.get(:testint, mode: 'integer').c1.should eq 0
    Settings.get(:testint, default: 5, mode: 'integer').c1.should eq 0
    Settings.get(:testint2, default: 5, mode: 'integer').c1.should eq 5
  end

  it 'support yaml mode' do
    Settings.get(:test_yml, mode: 'yaml').c1.should be_nil
    Settings.get(:test_yml_2, default: '[t1, t2, t3]', mode: 'yaml').c1.should eq ['t1', 't2', 't3']
  end
end