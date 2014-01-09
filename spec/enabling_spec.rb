# encoding: utf-8

require 'spec_helper'

describe 'Settings enabling and disabling' do
  it 'works for name_enabled? and name_enabled =' do
    Settings.zzz = '123'
    Settings.zzz.should eq '123'
    Settings.get(:zzz).enabled.should eq true
    Settings.enabled?(:zzz).should eq true
    Settings.zzz_enabled?.should eq true

    Settings.zzz.should eq '123'
    Settings.zzz_enabled = false
    Settings.zzz_enabled?.should eq false
    Settings.get(:zzz).enabled.should eq false
    Settings.enabled?(:zzz).should eq false
    Settings.zzz.should eq ''
    Settings.unload!
    Settings.zzz.should eq ''
    Settings.get(:zzz).raw.should eq '123'

    Settings.zzz_enabled = true
    Settings.zzz.should eq '123'
    Settings.zzz_enabled?.should eq true
    Settings.get(:zzz).enabled.should eq true
    Settings.enabled?(:zzz).should eq true
  end
end
