# encoding: utf-8

require 'spec_helper'

describe 'Settings enabling and disabling' do
  it 'works for name_enabled? and name_enabled =' do
    Settings.zzz = '123'
    expect(Settings.zzz).to eq '123'
    expect(Settings.get(:zzz).enabled).to eq true
    expect(Settings.enabled?(:zzz)).to eq true
    expect(Settings.zzz_enabled?).to eq true

    expect(Settings.zzz).to eq '123'
    Settings.zzz_enabled = false
    expect(Settings.zzz_enabled?).to eq false
    expect(Settings.get(:zzz).enabled).to eq false
    expect(Settings.enabled?(:zzz)).to eq false
    expect(Settings.zzz).to eq ''
    Settings.unload!
    expect(Settings.zzz).to eq ''
    expect(Settings.get(:zzz).raw).to eq '123'

    Settings.zzz_enabled = true
    expect(Settings.zzz).to eq '123'
    expect(Settings.zzz_enabled?).to eq true
    expect(Settings.get(:zzz).enabled).to eq true
    expect(Settings.enabled?(:zzz)).to eq true
  end
end
