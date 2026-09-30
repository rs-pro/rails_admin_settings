if RailsAdminSettings.active_record?
  module RailsAdminSettings
    class Setting < ActiveRecord::Base
    end
  end
end

module RailsAdminSettings
  class Setting
    if RailsAdminSettings.mongoid?
      include RailsAdminSettings::Mongoid
    end

    if RailsAdminSettings.active_record?
      self.table_name = "rails_admin_settings"

      def self.ransackable_attributes(_auth_object = nil)
        %w[id ns key label kind enabled created_at updated_at]
      end

      def self.ransackable_associations(_auth_object = nil)
        []
      end
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

    include RailsAdminSettings::RailsAdminConfig if defined?(::RailsAdmin)
  end
end
