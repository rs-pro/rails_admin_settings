ENV['RAILS_ENV'] = 'test'

require 'fileutils'

root = File.expand_path('../examples/demo', __dir__)
FileUtils.mkdir_p(File.join(root, 'tmp'))

require_relative '../examples/rails_admin/config/environment'
require 'capybara/rspec'
require 'capybara/cuprite'

ActiveRecord::MigrationContext.new(File.join(root, 'db/migrate')).migrate

Capybara.app = Rails.application
Capybara.register_driver :cuprite do |app|
  Capybara::Cuprite::Driver.new(app, browser_options: { 'no-sandbox' => nil }, window_size: [1280, 900])
end
Capybara.javascript_driver = :cuprite

RSpec.configure do |config|
  config.before do
    RailsAdminSettings::Setting.delete_all
    Settings.unload!
  end
  config.after do |example|
    if example.exception && example.metadata[:js]
      FileUtils.mkdir_p(Rails.root.join('tmp/capybara'))
      save_screenshot(Rails.root.join('tmp/capybara', "#{example.id.hash.abs}.png"))
    end
    Settings.unload!
  end
end
