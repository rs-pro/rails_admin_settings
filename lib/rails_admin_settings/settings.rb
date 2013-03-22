class Settings
  class << self
    def load!
      unless @@loaded
        @@settings = {}
        @@loaded = true
      end
    end

    def unload!
      @@settings = {}
      @@loaded = false
    end

    # returns processed setting value
    def method_missing(key, *args)
      if key[-1] == '='
        key = key[0..-2]
        options = args[1] || {}
        options[:default] = args.first
        create_setting(key, options)
      elsif @@settings[key].nil?
        create_setting(key, args.first || {})
      else
        @@settings[key]
      end

    end

    def set(key, value, options = {})
      load!
      key = key.to_s
      options.symbolize_keys!
      if @@settings[key].nil?
        @@settings[key] = RailsAdminSettings::Setting.create(options.merge(key: key, value: value))
      else
        @@settings[key].update_attributes!(options.merge(value: value))
      end
    end

    # returns setting object
    def get(key, options = {})
      load!
      key = key.to_s
      @@settings[key]
    end

    def []=(key, value)
      set(key, value)
    end

    def [](key)
      get(key)
    end

    def save_default(key, value, options = {})
      load!
      create_setting(key, value, options) if @@settings[key].nil?
    end

    def create_setting(key, value, options = {})
      load!
      options.symbolize_keys!
      @@settings[key] = RailsAdminSettings::Setting.create(options.merge(key: key, value: value)) if @@settings[key].nil?
    end

    # to satisfy rspec
    def to_ary
      ['Settings']
    end
  end

  self.unload!
end