module RailsAdminSettings
  class Engine < ::Rails::Engine
    rake_tasks do
      require File.expand_path('../tasks', __FILE__)
    end

    initializer 'RailsAdminSettings Install after_filter' do |app|
      require File.dirname(__FILE__) + '/../../app/models/rails_admin_settings/setting.rb'

      if defined?(ActionController) and defined?(ActionController::Base)
        ActionController::Base.class_eval do
          after_filter { Settings.unload! }
        end
      end
    end
  end
end
