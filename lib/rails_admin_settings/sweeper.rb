module RailsAdminSettings
  class Sweeper
    def controller
      Thread.current[:rails_admin_settings_sweeper_controller]
    end

    def controller=(value)
      Thread.current[:rails_admin_settings_sweeper_controller] = value
    end

    # Hook to ActionController::Base#around_filter.
    # Runs before a controller action is run.
    # It should always return true so controller actions
    # can continue.
    def before(controller)
      self.controller = controller
      self.controller.send(:load_settings)
      true
    end

    # Hook to ActionController::Base#around_filter.
    # Runs after a controller action is run.
    # Clean up so that the controller can
    # be collected after this request
    def after(controller)
      self.controller = nil
    end
  end
end
