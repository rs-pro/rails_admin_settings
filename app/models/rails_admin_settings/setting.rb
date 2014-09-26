if RailsAdminSettings.active_record?
  module RailsAdminSettings
    class Setting < ActiveRecord::Base
    end
  end
end

module RailsAdminSettings
  class Setting
    #binding.pry
    if RailsAdminSettings.mongoid?
      include RailsAdminSettings::Mongoid
    end

    if RailsAdminSettings.active_record?
      self.table_name = "rails_admin_settings"
    end

    scope :enabled, -> { where(enabled: true) }
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

    def type
      kind
    end

    def to_path
      if value.nil?
        nil
      else
        'public' + URI.parse(value).path
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
