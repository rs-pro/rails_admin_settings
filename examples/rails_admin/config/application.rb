require 'bundler/setup'
require 'rails'
require 'active_record/railtie'
require 'action_controller/railtie'
require 'action_view/railtie'
require 'sprockets/railtie'
require 'rails_admin'
require 'rails_admin_settings'

module RailsAdminSettingsDemo
  class Application < Rails::Application
    config.root = File.expand_path('..', __dir__)
    config.load_defaults 8.0
    config.eager_load = false
    config.secret_key_base = 'demo-only-rails-admin-secret-key-base-at-least-thirty-characters'
    config.hosts.clear
    config.active_record.dump_schema_after_migration = false
    config.paths['db/migrate'] = [File.expand_path('../../demo/db/migrate', __dir__)]
    config.paths['db/seeds.rb'] = [File.expand_path('../../demo/db/seeds.rb', __dir__)]
    config.logger = ActiveSupport::Logger.new($stdout)
    config.log_level = :warn
    config.action_controller.allow_forgery_protection = false if Rails.env.test?
    config.action_dispatch.show_exceptions = :none if Rails.env.test?
  end
end
