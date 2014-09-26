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
    expect(Settings.footer).to eq 'test <b></b>'
    expect(Settings.get(:footer).kind).to eq 'html'
  end

  it 'sets kind' do
    expect(Settings.get(:phone).phone_kind?).to be_truthy
    expect(Settings.get(:phone).val.city).to eq '906'
    expect(Settings.get(:phone).val.formatted_subscriber).to eq '111-11-11'
  end

  it 'sets enabled' do
    expect(Settings.phone_enabled?).to eq true
    expect(Settings.disabled_enabled?).to eq false
    expect(Settings.enabled?(:disabled)).to eq false
  end

  it 'works with namespace' do
    expect(Settings.ns(:main).phone).to eq '906 1111111'
    expect(Settings.ns(:other).footer).to eq 'zzz'
    expect(Settings.footer).to eq 'test <b></b>'
    expect(Settings.ns(:main).footer).to eq 'test <b></b>'
  end

  it 'works with fallback' do
    expect(Settings.ns(:etc, fallback: :main).phone).to eq '906 1111111'
    expect(Settings.ns(:etc, fallback: :main).footer).to eq 'test <b></b>'
    expect(Settings.ns(:other, fallback: :main).footer).to eq 'zzz'
    expect(Settings.ns(:etc, fallback: :other).footer).to eq 'zzz'
  end

  it 'works with custom default namespace' do
    Settings.ns_default = 'other'
    Settings.ns_fallback = 'other'
    expect(Settings.ns(:main).phone).to eq '906 1111111'
    expect(Settings.ns(:other).footer).to eq 'zzz'
    expect(Settings.ns(:main).footer).to eq 'test <b></b>'
    expect(Settings.footer).to eq 'zzz'

    expect(Settings.ns(:etc, fallback: :main).phone).to eq '906 1111111'
    expect(Settings.ns(:etc, fallback: :main).footer).to eq 'test <b></b>'
    expect(Settings.ns(:other, fallback: :main).footer).to eq 'zzz'
    expect(Settings.ns(:etc, fallback: :other).footer).to eq 'zzz'

    Settings.ns_default = :etc
    Settings.ns_fallback = :main
    expect(Settings.phone).to eq '906 1111111'
    expect(Settings.footer).to eq 'test <b></b>'

    Settings.ns_fallback = :other
    expect(Settings.footer).to eq 'zzz'

    Settings.ns_default = :other
    Settings.ns_fallback = :main
    expect(Settings.footer).to eq 'zzz'
  end

  it "doesn't overwrite" do
    Settings.ns(:main).phone = '906 2222222'
    Settings.ns(:other).footer = 'xxx'
    Settings.apply_defaults!(File.join(File.dirname(__FILE__), 'support/defaults.yml'))
    expect(Settings.ns(:main).phone).to eq '906 2222222'
    expect(Settings.ns(:other).footer).to eq 'xxx'
  end
end
