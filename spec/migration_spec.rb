# encoding: utf-8

require 'spec_helper'

describe 'Migrating from old versions' do
  it 'sets ns' do
    RailsAdminSettings::Setting.collection.insert({enabled: true, key: 'test', raw: '9060000000', type: 'phone'})
    RailsAdminSettings.migrate!
    RailsAdminSettings::Setting.first.key.should eq 'test'
    RailsAdminSettings::Setting.first.raw.should eq '9060000000'
    RailsAdminSettings::Setting.first.ns.should eq 'main'
    RailsAdminSettings::Setting.first.kind.should eq 'phone'
  end
end

