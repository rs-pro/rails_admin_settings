require 'bundler/setup'
require 'rails'
require 'active_record/railtie'
require 'action_controller/railtie'
require 'action_view/railtie'
require 'sprockets/railtie'
require 'importmap-rails'
require 'active_admin'
require 'rails_admin_settings'

module SettingsDemo
  class Application < Rails::Application
    config.root = File.expand_path('..', __dir__)
    config.load_defaults 8.0
    config.eager_load = false
    config.active_record.dump_schema_after_migration = false
    config.secret_key_base = 'demo-only-secret-key-base-at-least-thirty-characters'
    config.hosts.clear
    config.assets.paths.unshift root.join('app/assets').to_s
    config.logger = ActiveSupport::Logger.new($stdout)
    config.log_level = :warn
    config.action_controller.allow_forgery_protection = false if Rails.env.test?
    config.action_dispatch.show_exceptions = :none if Rails.env.test?
  end
end
