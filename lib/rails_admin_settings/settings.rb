class Settings
  cattr_accessor :file_uploads_supported, :file_uploads_engine
  @@file_uploads_supported = false
  @@file_uploads_engine = false

  class << self
    @@loaded = false
    @@settings = {}

    def load!
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

    def unload!
      if @@loaded
        @@settings = {}
        @@loaded = false
        true
      else
        false
      end
    end

    # returns processed setting value
    def method_missing(key, *args)
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

      if @@settings[key].nil?
        @@settings[key] = RailsAdminSettings::Setting.create(options.merge(key: key, raw: value))
      else
        @@settings[key].update_attributes!(options.merge(raw: value))
        @@settings[key]
      end
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
      options.merge!(default: value)
      create_setting(key, options) if @@settings[key].nil?
    end

    def create_setting(key, options = {})
      load!
      options.symbolize_keys!
      options[:raw] = options.delete(:default)
      @@settings[key] = RailsAdminSettings::Setting.create!(options.merge(key: key)) if @@settings[key].nil?
    end

    # to satisfy rspec
    def to_ary
      ['Settings']
    end
  end
end