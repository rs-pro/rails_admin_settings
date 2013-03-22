module RailsAdminSettings
  module RequireHelpers
    private

    def require_russian_phone
      begin
        require 'russian_phone'
        yield
      rescue LoadError => e
        e.message << " [rails_admin_settings] Please add gem 'russian_phone' to use phone settings"
        raise e
      end
    end

    def require_safe_yaml
      begin
        require 'safe_yaml'
        yield
      rescue LoadError => e
        e.message << " [rails_admin_settings] Please add gem 'safe_yaml' to your Gemfile to use yaml settings"
        raise e
      end
    end

    def require_sanitize
      begin
        require 'sanitize'
        yield
      rescue LoadError => e
        e.message << " [rails_admin_settings] Please install sanitize to use sanitized settings"
        raise e
      end
    end
  end
end

