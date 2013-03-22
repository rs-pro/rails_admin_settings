module RailsAdminSettings
  class Engine < ::Rails::Engine
    initializer 'Include RailsAdminSettings Helper' do |app|
      ActionController::Base.send :include, RailsAdminSettings::ControllerHelper
      ActionView::Base.send :include, RailsAdminSettings::Helper

      if defined?(ActionController) and defined?(ActionController::Base)
        ActionController::Base.class_eval do
          before_filter { |controller| RailsAdminSettings::Sweeper.instance.before(controller) }
          after_filter { |controller| RailsAdminSettings::Sweeper.instance.after(controller) }
        end
      end
    end
  end
end
