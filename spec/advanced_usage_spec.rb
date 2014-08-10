# encoding: utf-8

require 'spec_helper'

describe 'Settings advanced usage' do
  it 'with defaults' do
    s = Settings.email(default: 'test@example.com')
    expect(s).to eq 'test@example.com'
    expect(Settings.get(:email).to_s).to eq 'test@example.com'
  end
end