module RailsAdminSettings
  # we are inheriting from BasicObject so we don't get a bunch of methods from
  # Kernel or Object
  class Namespaced < BasicObject
    attr_accessor :settings, :fallback
    attr_reader :loaded, :mutex, :ns_mutex, :name

    def initialize(name)
      self.settings = {}
      @mutex = ::Mutex.new
      @ns_mutex = ::Mutex.new
      @loaded = false
      @locked = false
      @name = name
    end

    def nil?
      false
    end
    def inspect
      "#<RailsAdminSettings::Namespaced name: #{@name.inspect}, fallback: #{@fallback.inspect}, loaded: #{@loaded}>"
    end
    def pretty_inspect
      inspect
    end

    def load!
      mutex.synchronize do
        return if loaded
        @loaded = true
        @settings = {}
        ::RailsAdminSettings::Setting.ns(@name).each do |setting|
          @settings[setting.key] = setting
        end
      end
    end

    def unload!
      mutex.synchronize do
        @loaded = false
        @settings = {}
      end
    end

    # returns setting object
    def get(key, options = {})
      load!
      key = key.to_s
      mutex.synchronize do
        @locked = true
        v = @settings[key]
        if v.nil?
          unless @fallback.nil? || @fallback == @name
            v = ::Settings.ns(@fallback).getnc(key)
          end
          if v.nil?
            v = set(key, options[:default], options)
          end
        end
        @locked = false
        v
      end
    end

    # returns setting object
    def getnc(key)
      load!
      mutex.synchronize do
        self.settings[key]
      end
    end

    def set(key, value = nil, options = {})
      load! unless @locked
      key = key.to_s
      options.symbolize_keys!

      if !options[:type].nil? && options[:type] == 'yaml' && !value.nil?
        if value.class.name != 'String'
          value = value.to_yaml
        end
      end

      options.merge!(value: value)
      if @locked
        write_to_database(key, options)
      else
        mutex.synchronize do
          write_to_database(key, options)
        end
      end
    end

    def enabled?(key, options = {})
      get(key, options).enabled?
    end

    def []=(key, value)
      set(key, value)
    end
    def [](key)
      get(key)
    end

    def destroy!(key)
      load!
      key = key.to_s
      mutex.synchronize do
        ::RailsAdminSettings::Setting.where(ns: @name, key: key).destroy_all
        @settings.delete(key)
      end
    end

    def destroy_all!
      mutex.synchronize do
        ::RailsAdminSettings::Setting.where(ns: @name).destroy_all
        @loaded = false
        @settings = {}
      end
    end

    # returns processed setting value
    def method_missing(key, *args)
      key = key.to_s
      if key.end_with?('_enabled?')
        key = key[0..-10]
        v = get(key)
        if v.nil?
          set(key, '').enabled
        else
          v.enabled
        end
      elsif key.end_with?('_enabled=')
        key = key[0..-10]
        v = get(key)
        if ::RailsAdminSettings.mongoid?
          if ::Mongoid::VERSION >= "4.0.0"
            v.set(enabled: args.first)
          else
            v.set("enabled", args.first)
          end
        else
          v.enabled = args.first
          v.save!
        end
        v.enabled
      elsif key.end_with?('=')
        key = key[0..-2]
        options = args[1] || {}
        value = args.first
        set(key, value, options).val
      else
        v = get(key, args.first || {})
        if v.nil?
          ''
        else
          v.val
        end
      end
    end

    def write_to_database(key, options)
      is_file = !options[:kind].nil? && (options[:kind] == 'image' || options[:kind] == 'file')
      if is_file
        options[:raw] = ''
        file = options[:value]
      else
        options[:raw] = options[:value]
      end

      options.delete(:value)
      options.delete(:default)
      options[:ns] = @name

      if @settings[key].nil?
        options.delete(:overwrite)
        v = ::RailsAdminSettings::Setting.create(options.merge(key: key))
        if !v.persisted?
          if v.errors[:key].any?
            v = ::RailsAdminSettings::Setting.where(key: key).first
            if v.nil?
              ::Kernel.raise ::RailsAdminSettings::PersistenceException, 'Fatal: error in key and not in DB'
            end
          else
            ::Kernel.raise ::RailsAdminSettings::PersistenceException, v.errors.full_messages.join(',')
          end
        end
        @settings[key] = v
      else
        opts = options.dup
        if options[:overwrite] == false && !@settings[key].value.blank?
          opts.delete(:raw)
          opts.delete(:value)
          opts.delete(:enabled)
        end
        opts.delete(:overwrite)
        @settings[key].update_attributes!(opts)
      end
      if is_file
        if options[:overwrite] != false || !@settings[key].file?
          @settings[key].file = file
          @settings[key].save!
        end
      end
      @settings[key]
    end
  end
end
