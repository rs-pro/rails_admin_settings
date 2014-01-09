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
    
    field :enabled, type: Mongoid::VERSION.to_i < 4 ? Boolean : Mongoid::Boolean, default: true
    scope :enabled, -> { where(enabled: true) }

    field :type, type: String, default: RailsAdminSettings.types.first

    field :ns, type: String, default: 'main'
    field :key, type: String
    index({ns: 1, key: 1}, {unique: true, sparse: true})

    field :raw, type: String
    field :label, type: String

    scope :ns, ->(ns) { where(ns: ns) }

    include RailsAdminSettings::RequireHelpers
    include RailsAdminSettings::Processing
    include RailsAdminSettings::Uploads
    include RailsAdminSettings::Validation

    def disabled?
      !enabled
    end

    def enabled?
      enabled
    end

    def name
      label.blank? ? key : label
    end

    def to_path
      if value.nil?
        nil
      else
        URI.parse(value).path
      end
    end

    def as_yaml(options = {})
      v = {type: type, enabled: enabled, label: label}
      if upload_type?
        v[:value] = to_path
      else
        v[:value] = raw
      end
      v.stringify_keys!
      v
    end

    if Object.const_defined?('RailsAdmin')
      include RailsAdminSettings::RailsAdminConfig
    else
      puts "[rails_admin_settings] Rails Admin not detected -- put this gem after rails_admin in gemfile"
    end
  end
end
