# encoding: utf-8

require 'spec_helper'

describe 'Namespaced settings' do
  before :each do 
   Settings.destroy_all!
  end

  it 'sets namespaced' do
    Settings.ns(:other).test = 'test'
  end

  it 'reads namespaced from cache' do
    ns = Settings.ns(:other)
    ns.test = 'test'
    expect(ns.test).to eq 'test'
  end

  it 'reads namespaced from db' do
    Settings.ns(:other).test = 'test'
    expect(Settings.ns(:other).test).to eq 'test'
  end

  it 'destroys' do
    Settings.ns(:other).test = 'test'
    Settings.ns(:other).destroy_all!
    expect(Settings.ns(:other).test).to eq ''
  end

  it 'sets kind' do
    expect {
      Settings.ns(:other).set(:phone, 'test', kind: 'phone')
    }.to raise_error
    Settings.ns(:other).set(:phone, '906 111 11 11', kind: 'phone')
    expect(Settings.get(:phone, ns: 'other').phone_kind?).to be_truthy
    expect(Settings.get(:phone, ns: 'other').val.city).to eq '906'
    expect(Settings.get(:phone, ns: 'other').val.formatted_subscriber).to eq '111-11-11'

    ns = Settings.ns(:other)
    expect(ns.get(:phone).phone_kind?).to be_truthy
    expect(ns.get(:phone).val.city).to eq '906'
    expect(ns.get(:phone).val.formatted_subscriber).to eq '111-11-11'
  end

  it 'works with custom defaults' do
    Settings.ns_default = 'hitfood'
    Settings.ns_fallback = 'main'
    expect(Settings.test).to eq ''
    Settings.test = 'zzz'
    expect(Settings.get(:test, ns: 'hitfood').raw).to eq 'zzz'
    expect(Settings.get(:test, ns: 'main').raw).to eq ''
  end

  it 'falls back to default ns' do
    Settings.ns_default = 'main'
    Settings.ns_fallback = 'main'

    Settings.ns(:main).test = 'main'
    Settings.ns(:other).test = 'other'

    expect(Settings.ns('main').test).to eq 'main'
    expect(Settings.ns('other').test).to eq 'other'
    expect(Settings.ns('other1').test).to eq 'main'
    expect(Settings.ns('other2', fallback: nil).test).to eq ''
  end
end
