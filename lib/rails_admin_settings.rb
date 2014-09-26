require "rails_admin_settings/version"

module RailsAdminSettings
  class << self
    def orm
      if defined?(::Mongoid)
        :mongoid
      else
        :active_record
      end
    end

    def mongoid?
      orm == :mongoid
    end

    def active_record?
      orm == :active_record
    end
  end

  class PersistenceException < Exception
  end

  autoload :Mongoid,           "rails_admin_settings/mongoid"
  autoload :Fallback,          "rails_admin_settings/fallback"
  autoload :Namespaced,        "rails_admin_settings/namespaced"
  autoload :Processing,        "rails_admin_settings/processing"
  autoload :Validation,        "rails_admin_settings/validation"
  autoload :RequireHelpers,    "rails_admin_settings/require_helpers"
  autoload :RailsAdminConfig,  "rails_admin_settings/rails_admin_config"
  autoload :Uploads,           "rails_admin_settings/uploads"
  autoload :HexColorValidator, "rails_admin_settings/hex_color_validator"
  autoload :Dumper,            "rails_admin_settings/dumper"

  def self.migrate!
    if RailsAdminSettings.mongoid?
      RailsAdminSettings::Setting.where(:ns.exists => false).update_all(ns: 'main')
      RailsAdminSettings::Setting.all.each do |s|
        s.kind = s.read_attribute(:type) if !s.read_attribute(:type).blank? && s.kind != s.read_attribute(:type)
        s.save! if s.changed?
        s.unset(:type)
      end
    else
      if Settings.table_exists?
        RailsAdminSettings::Setting.where("ns IS NULL").update_all(ns: 'main')
      end
    end
  end

  def self.track_history!
    return false unless Settings.table_exists?

    if mongoid?
      if Mongoid.const_defined?('History')
        RailsAdminSettings::Setting.send(:include, ::Mongoid::History::Trackable)
        RailsAdminSettings::Setting.send(:track_history, {track_create: true, track_destroy: true})
      else
        puts "[rails_admin_settings] WARN unable to track_history: Mongoid::History not loaded!"
      end
      if Mongoid.const_defined?('Userstamp')
        RailsAdminSettings::Setting.send(:include, ::Mongoid::Userstamp)
      else
        puts "[rails_admin_settings] WARN unable to track_history: Mongoid::Userstamp not loaded!"
      end
    elsif active_record?
      if defined?(PaperTrail) && PaperTrail::Version.table_exists?
        RailsAdminSettings::Setting.send(:has_paper_trail)
      end
    end
  end
end

require "rails_admin_settings/kinds"
require "rails_admin_settings/settings"

if Object.const_defined?('Rails')
  require "rails_admin_settings/engine"
else
  require File.dirname(__FILE__) + '/../app/models/rails_admin_settings/setting.rb'
end
