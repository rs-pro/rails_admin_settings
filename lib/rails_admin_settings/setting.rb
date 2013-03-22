# coding: utf-8
module RailsAdminSettings
  class Setting
    include ::Mongoid::Document
    include ::Mongoid::Timestamps::Short

    store_in collection: "rails_admin_settings"

    if Object.const_defined?('Mongoid') && Mongoid.const_defined?('Audit')
      include ::Mongoid::Audit::Trackable
      track_history track_create: true, track_destroy: true
    end

    field :enabled, type: Boolean, default: true
    scope :enabled, where(enabled: true)

    field :type, type: String, default: RailsAdminSettings.types.first

    field :key, type: String
    field :raw, type: String, default: ''

    include RailsAdminSettings::RequireHelpers
    include RailsAdminSettings::Processing
    include RailsAdminSettings::Validation

    def disabled?
      !enabled
    end

    def enabled?
      enabled
    end

    index(key: 1)

    if respond_to?(:rails_admin)
      include RailsAdminSettings::RailsAdminConfig
    end
  end
end