# coding: utf-8
module RailsAdminSettings
  def self.types
    ['string', 'integer', 'html', 'sanitized', 'yaml', 'phone']
  end

  class Setting
    include ::Mongoid::Document
    include ::Mongoid::Timestamps::Short

    if Object.const_defined?('Mongoid') && Mongoid.const_defined?('Audit')
      include ::Mongoid::Audit::Trackable
      track_history track_create: true, track_destroy: true
    end

    field :enabled, type: Boolean, default: true
    scope :enabled, where(enabled: true)

    field :type, type: String, default: RailsAdminSettings.types.first

    field :key, type: String
    field :value, type: String, default: ''

    include RailsAdminSettings::RequireHelpers
    include RailsAdminSettings::TypeHelpers
    include RailsAdminSettings::Processing

    def disabled?
      !enabled
    end

    def enabled?
      enabled
    end



    if respond_to?(:rails_admin)
      include RailsAdminSettings::RailsAdminConfig
    end
  end
end