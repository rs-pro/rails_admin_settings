require 'thread'

class Settings
  cattr_accessor :file_uploads_supported, :file_uploads_engine, :settings
  @@file_uploads_supported = false
  @@file_uploads_engine = false
  @@mutex = Mutex.new

  class << self
    @@loaded = false
    @@settings = {}

    def load!
      @@mutex.synchronize do
        if @@loaded
          false
        else
          @@settings = {}
          RailsAdminSettings::Setting.all.each do |setting|
            @@settings[setting.key] = setting
          end
          @@loaded = true
          true
        end
      end
    end

    def unload!
      @@mutex.synchronize do
        if @@loaded
          @@settings = {}
          @@loaded = false
          true
        else
          false
        end
      end
    end

    # returns processed setting value
    def method_missing(key, *args)
      key = key.to_s

      if key[-1] == '='
        key = key[0..-2]
        options = args[1] || {}
        value = args.first
        set(key, value, options).val
      else
        get(key, args.first || {}).val
      end
    end

    def set(key, value = nil, options = {})
      load!
      key = key.to_s
      options.symbolize_keys!


      if !options[:type].nil? && options[:type] == 'yaml' && !value.nil? && !valid_yaml?(value)
        value = value.to_yaml
      end

      is_file = !options[:type].nil? && (options[:type] == 'image' || options[:type] == 'file')
      if is_file
        options[:raw] = ''
      else
        options[:raw] = value
      end

      if @@settings[key].nil?
        write_to_database(key, options.merge(key: key))
      else
        @@mutex.synchronize do
          @@settings[key].update_attributes!(options)
        end
      end

      if is_file
        @@mutex.synchronize do
          @@settings[key].file = value
          @@settings[key].save!
        end
      end

      @@settings[key]
    end

    def valid_yaml?(value)
      begin
        YAML.safe_load(value)
      rescue LoadError => e
        e.message << " [rails_admin_settings] Please add gem 'safe_yaml' to your Gemfile to use yaml settings"
        raise e
      rescue Psych::SyntaxError => e
        return false
      end
    end

    def enabled?(key, options = {})
      get(key, options).enabled?
    end

    # returns setting object
    def get(key, options = {})
      load!
      key = key.to_s
      if @@settings[key].nil?
        create_setting(key, options)
      else
        @@settings[key]
      end
    end

    def []=(key, value)
      set(key, value)
    end

    def [](key)
      get(key)
    end

    def save_default(key, value, options = {})
      load!
      key = key.to_s
      options.merge!(default: value)

      if @@settings[key].nil?
        create_setting(key, options).val
      else
        if @@settings[key].blank?
          set(key, value).val
        else
          @@settings[key].val
        end
      end
    end

    def create_setting(key, options = {})
      load!
      key = key.to_s
      options.symbolize_keys!
      options[:raw] = options.delete(:default)

      if @@settings[key].nil?
        write_to_database(key, options.merge(key: key))
      else
        @@settings[key]
      end
    end

    # to satisfy rspec
    def to_ary
      ['Settings']
    end

    def destroy(key)
      raise 'please call destroy! to delete setting'
    end

    def destroy_all
      raise 'please call destroy_all! to delete all settings'
    end

    def destroy!(key)
      load!
      key = key.to_s

      @@mutex.synchronize do
        unless @@settings[key].nil?
          @@settings[key].destroy
          @@settings.delete(key)
        end
      end
    end

    def destroy_all!
      RailsAdminSettings::Setting.destroy_all
      unload!
    end


    def write_to_database(key, options)
      key = key.to_s

      @@mutex.synchronize do
        @@settings[key] = RailsAdminSettings::Setting.create(options)
        unless @@settings[key].persisted?
          if @@settings[key].errors[:key].any?
            @@settings[key] = RailsAdminSettings::Setting.where(key: key).first
            if options[:raw].blank? && !@@settings[key].blank?
              # do not update setting if it's not blank in DB and we want to make it blank
            else
              unless @@settings[key].update_attributes(options)
                raise RailsAdminSettings::PersistenceException
              end
            end
          end
        end
        @@settings[key]
      end
    end

    def label key
      get(key).label
    end
  end
end
