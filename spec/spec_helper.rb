$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'rubygems'

require 'simplecov'
SimpleCov.start

require 'bundler/setup'
require 'active_support/core_ext'
require 'mongoid'
require 'database_cleaner'
require 'factory_girl'
require 'mongoid-rspec'

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each do |f|
  require f
end

require 'rails_admin_settings'

Dir["#{File.dirname(__FILE__)}/factories/**/*.rb"].each do |f|
  require f
end
