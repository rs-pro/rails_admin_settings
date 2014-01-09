# encoding: utf-8

require 'spec_helper'

describe 'Settings loading defaults' do
  before :each do
    Settings.apply_defaults!(File.join(File.dirname(__FILE__), 'support/defaults.yml'))
  end

  it 'loads twice ok' do
    Settings.apply_defaults!(File.join(File.dirname(__FILE__), 'support/defaults.yml'))
    Settings.apply_defaults!(File.join(File.dirname(__FILE__), 'support/defaults.yml'))
  end

  it 'sets value' do
    Settings.footer.should eq 'test <b></b>'
    Settings.get(:footer).type.should eq 'html'
  end

  it 'sets type' do
    Settings.get(:phone).phone_type?.should be_true
    Settings.get(:phone).val.city.should eq '906'
    Settings.get(:phone).val.formatted_subscriber.should eq '111-11-11'
  end

  it 'sets enabled' do
    Settings.phone_enabled?.should eq true
    Settings.disabled_enabled?.should eq false
    Settings.enabled?(:disabled).should eq false
  end

  it 'works with namespace' do
    Settings.ns(:main).phone.should eq '906 1111111'
    Settings.ns(:other).footer.should eq 'zzz'
    Settings.footer.should eq 'test <b></b>'
    Settings.ns(:main).footer.should eq 'test <b></b>'
  end

  it 'works with fallback' do
    Settings.ns(:etc, fallback: :main).phone.should eq '906 1111111'
    Settings.ns(:etc, fallback: :main).footer.should eq 'test <b></b>'
    Settings.ns(:other, fallback: :main).footer.should eq 'zzz'
    Settings.ns(:etc, fallback: :other).footer.should eq 'zzz'
  end

  it "doesn't overwrite" do
    Settings.ns(:main).phone = '906 2222222'
    Settings.ns(:other).footer = 'xxx'
    Settings.apply_defaults!(File.join(File.dirname(__FILE__), 'support/defaults.yml'))
    Settings.ns(:main).phone.should eq '906 2222222'
    Settings.ns(:other).footer.should eq 'xxx'
  end
end
