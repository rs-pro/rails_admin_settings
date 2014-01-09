require "rails_admin_settings/version"

module RailsAdminSettings
  class PersistenceException < Exception
  end

  autoload :Fallback,          "rails_admin_settings/fallback"
  autoload :Namespaced,        "rails_admin_settings/namespaced"
  autoload :Processing,        "rails_admin_settings/processing"
  autoload :Validation,        "rails_admin_settings/validation"
  autoload :RequireHelpers,    "rails_admin_settings/require_helpers"
  autoload :RailsAdminConfig,  "rails_admin_settings/rails_admin_config"
  autoload :Uploads,           "rails_admin_settings/uploads"
  autoload :HexColorValidator, "rails_admin_settings/hex_color_validator"
  autoload :Dumper,            "rails_admin_settings/dumper"
end

require "rails_admin_settings/types"
require "rails_admin_settings/settings"

if Object.const_defined?('Rails')
  require "rails_admin_settings/railtie"
  require "rails_admin_settings/engine"
else
  require File.dirname(__FILE__) + '/../app/models/rails_admin_settings/setting.rb'
end
