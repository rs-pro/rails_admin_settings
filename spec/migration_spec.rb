# encoding: utf-8

require 'spec_helper'

describe 'Migrating from old versions' do
  it 'sets ns' do
    coll = RailsAdminSettings::Setting.collection
    if coll.respond_to?(:insert_one)
      coll.insert_one({enabled: true, key: 'test', raw: '9060000000', type: 'phone'})
    else
      coll.insert({enabled: true, key: 'test', raw: '9060000000', type: 'phone'})
    end
    RailsAdminSettings.migrate!
    expect(RailsAdminSettings::Setting.first.key).to eq 'test'
    expect(RailsAdminSettings::Setting.first.raw).to eq '9060000000'
    expect(RailsAdminSettings::Setting.first.ns).to eq 'main'
    expect(RailsAdminSettings::Setting.first.kind).to eq 'phone'
  end
end

