require "rails_admin_settings/version"

require "rails_admin_settings/setting"
require "rails_admin_settings/settings"

require "rails_admin_settings/helper"
require "rails_admin_settings/controller_helper"

require "rails_admin_settings/sweeper"

if Object.const_defined?('Rails')
  require "rails_admin_settings/engine"
end
