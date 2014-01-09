# encoding: utf-8

require 'spec_helper'

describe 'Namespaced settings' do
  it 'sets namespaced' do
    Settings.ns(:other).test = 'test'
  end

  it 'reads namespaced from cache' do
    ns = Settings.ns(:other)
    ns.test = 'test'
    ns.test.should eq 'test'
  end

  it 'reads namespaced from db' do
    Settings.ns(:other).test = 'test'
    Settings.ns(:other).test.should eq 'test'
  end

  it 'destroys' do
    Settings.ns(:other).test = 'test'
    Settings.ns(:other).destroy_all!
    Settings.ns(:other).test.should eq ''
  end

  it 'sets type' do
    expect {
      Settings.ns(:other).set(:phone, 'test', type: 'phone')
    }.to raise_error
    Settings.ns(:other).set(:phone, '906 111 11 11', type: 'phone')
    Settings.get(:phone, ns: 'other').phone_type?.should be_true
    Settings.get(:phone, ns: 'other').val.city.should eq '906'
    Settings.get(:phone, ns: 'other').val.formatted_subscriber.should eq '111-11-11'

    ns = Settings.ns(:other)
    ns.get(:phone).phone_type?.should be_true
    ns.get(:phone).val.city.should eq '906'
    ns.get(:phone).val.formatted_subscriber.should eq '111-11-11'
  end
end
