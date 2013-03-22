# coding: utf-8

FactoryGirl.define do
  factory :setting, class: RailsAdminSettings::Setting do
    sequence(:code){|n| "block_#{n}" }
    mode "doublehtml"
    content_1 "Контент 1"
    content_2 "Контент 2"
    enabled true
  end
end
