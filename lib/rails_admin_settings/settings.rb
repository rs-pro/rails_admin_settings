require 'thread'

# we are inheriting from BasicObject so we don't get a bunch of methods from
# Kernel or Object
class Settings < BasicObject
  cattr_accessor :file_uploads_supported, :file_uploads_engine
  @@file_uploads_supported = false
  @@file_uploads_engine = false
  @@namespaces = {}
  @@mutex = ::Mutex.new

  @@ns_default = 'main'
  @@ns_fallback = nil
  cattr_accessor :ns_default, :ns_fallback, :namespaces

  cattr_reader :mutex

  class << self
    def ns(name, options = {})
      options.symbolize_keys!
      if name.nil? || name == @@ns_default
        name = @@ns_default.to_s
      else
        name = name.to_s
      end
      if options.key?(:type)
        options[:kind] = options.delete(:type)
      end
      @@mutex.synchronize do
        @@namespaces[name] ||= ::RailsAdminSettings::Namespaced.new(name.to_s)
      end
      fallback = options.key?(:fallback) ? options[:fallback] : @@ns_fallback
      ::RailsAdminSettings::Fallback.new(@@namespaces[name], fallback)
    end

    def get_default_ns
      ns(nil, fallback: @@ns_fallback)
    end

    def table_exists?
      RailsAdminSettings.mongoid? || RailsAdminSettings::Setting.table_exists?
    end

    def unload!
      @@mutex.synchronize do
        @@namespaces.values.map(&:unload!)
        @@namespaces = {}
        @@ns_default = 'main'
        @@ns_fallback = nil
      end
    end

    def destroy_all!
      RailsAdminSettings::Setting.destroy_all
      unload!
    end

    def root_file_path
      if defined?(Rails)
        Rails.root
      else
        Pathname.new(File.dirname(__FILE__)).join('../..')
      end
    end

    def apply_defaults!(file, verbose = false)
      RailsAdminSettings.apply_defaults!(file, verbose)
    end

    def get(key, options = {})
      options.symbolize_keys!
      ns(options[:ns], options).get(key, options)
    end

    def set(key, value = nil, options = {})
      options.symbolize_keys!
      ns(options[:ns], options).set(key, value, options)
    end

    def save_default(key, value, options = {})
      set(key, value, options.merge(overwrite: false))
    end

    def create_setting(key, value, options = {})
      set(key, nil, options.merge(overwrite: false))
    end

    def method_missing(*args)
      get_default_ns.__send__(*args)
    end
  end
end

