# coding: utf-8

FactoryBot.define do
  factory :setting, class: RailsAdminSettings::Setting do
    sequence(:key){|n| "setting_#{n}" }
    raw { "Контент 1" }
  end
end
