require "rails_admin_settings/version"

module RailsAdminSettings
  class PersistenceException < Exception
  end

  autoload :Processing,       "rails_admin_settings/processing"
  autoload :Validation,       "rails_admin_settings/validation"
  autoload :RequireHelpers,   "rails_admin_settings/require_helpers"
  autoload :RailsAdminConfig, "rails_admin_settings/rails_admin_config"
  autoload :Uploads,          "rails_admin_settings/uploads"
end

require "rails_admin_settings/types"
require "rails_admin_settings/settings"

if Object.const_defined?('Rails')
  require "rails_admin_settings/engine"
else
  require File.dirname(__FILE__) + '/../app/models/rails_admin_settings/setting.rb'
end
