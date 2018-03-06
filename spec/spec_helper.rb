$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'rubygems'

require 'simplecov'
SimpleCov.start

require 'pry'
require 'bundler/setup'
require 'active_support'
require 'active_support/core_ext'

unless ENV['ACTIVERECORD']
  require 'mongoid'
end

require 'database_cleaner'
require 'factory_bot'
require 'mongoid-rspec'

require "mongoid-paperclip" if ENV['UPLOADS'] == 'paperclip'
if ENV['UPLOADS'] == 'carrierwave'
  require "carrierwave/mongoid"
  CarrierWave.configure do |config|
    config.asset_host = proc do |file|
      "http://localhost"
    end
  end
end

I18n.enforce_available_locales = true
I18n.load_path << File.join(File.dirname(__FILE__), "..", "config", "locales", "en.yml")

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each do |f|
  require f
end

require "active_model/railtie"
require "action_controller/railtie"
require "action_view/railtie"
module RAS
  class Application < Rails::Application
  end
end
# Initialize the Rails application.
Rails.application.initialize!

require 'rails_admin_settings'

Dir["#{File.dirname(__FILE__)}/factories/**/*.rb"].each do |f|
  require f
end

#RSpec.configure do |config|
  #config.expect_with(:rspec) { |c| c.syntax = :should }
#end
