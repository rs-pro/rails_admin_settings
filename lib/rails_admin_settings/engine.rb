module RailsAdminSettings
  class Engine < ::Rails::Engine
    rake_tasks do
      require File.expand_path('../tasks', __FILE__)
    end

    initializer 'rails_admin_settings.clear_request_cache' do
      if defined?(ActionController) and defined?(ActionController::Base)
        ActionController::Base.class_eval do
          after_action { Settings.unload! }
        end
      end
    end

    initializer 'rails_admin_settings.active_admin', after: :load_config_initializers do
      if defined?(::ActiveAdmin::DSL)
        ::ActiveAdmin::DSL.include(RailsAdminSettings::ActiveAdminDSL)
      end
    end
  end
end
