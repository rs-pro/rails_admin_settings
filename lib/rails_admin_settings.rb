require "rails_admin_settings/version"

module RailsAdminSettings
  if defined?(Rails) && defined?(Rails::Html) && defined?(Rails::Html::WhiteListSanitizer)
    @@scrubber = Rails::Html::WhiteListSanitizer.new
  end
  cattr_accessor :scrubber

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

  def self.apply_defaults!(file, verbose = false)
    if File.file?(file)
      puts "[settings] Loading from #{file}" if verbose
      if defined?(Psych) && Psych.respond_to?(:safe_load)
        yaml = Psych.safe_load(File.read(file))
      else
        yaml = YAML.load(File.read(file), safe: true)
      end
      yaml.each_pair do |namespace, vals|
        vals.symbolize_keys!
        n = Settings.ns(namespace)
        vals.each_pair do |key, val|
          val.symbolize_keys!
          if !val[:kind].nil? && (val[:kind] == 'file' || val[:kind] == 'image')
            unless Settings.file_uploads_supported
              raise PersistenceException, "Fatal: setting #{key} is #{val[:type]} but file upload engine is not detected"
            end
            value = File.open(root_file_path.join(val.delete(:value)))
          else
            value = val.delete(:value)
          end
          puts "#{key} - default '#{value}' current '#{Settings.get(key).raw}'" if verbose
          n.set(key, value, val.merge(overwrite: false))
        end
        n.unload!
      end
    end
  end

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
      if ::Mongoid.const_defined?('History')
        RailsAdminSettings::Setting.send(:include, ::Mongoid::History::Trackable)
        RailsAdminSettings::Setting.send(:track_history, {track_create: true, track_destroy: true})
      else
        puts "[rails_admin_settings] WARN unable to track_history: Mongoid::History not loaded!"
      end
      if ::Mongoid.const_defined?('Userstamp')
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
