# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rails_admin_settings/version'

Gem::Specification.new do |spec|
  spec.name          = "rails_admin_settings"
  spec.version       = RailsAdminSettings::VERSION
  spec.authors       = ["Gleb Tv"]
  spec.email         = ["glebtv@gmail.com"]
  spec.description   = %q{Mongoid / ActiveRecord + RailsAdmin App Settings management}
  spec.summary       = 'Application settings for RailsAdmin and ActiveAdmin'
  spec.homepage      = "https://gitlab.com/rocket-science/rails_admin_settings"
  spec.license       = "MIT"

  spec.files         = `git ls-files --cached --others --exclude-standard`.split($/).select { |file| File.file?(file) }
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]


  spec.required_ruby_version = '>= 3.2'

  spec.add_dependency 'rails', '>= 8.0', '< 9'

  spec.add_development_dependency "rails_admin", '~> 3.3'
  spec.add_development_dependency "activeadmin", '>= 4.0.0.beta22', '< 5'
  spec.add_development_dependency "sqlite3", '>= 2.1'
  spec.add_development_dependency "capybara"
  spec.add_development_dependency "cuprite"
  spec.add_development_dependency "puma"
  spec.add_development_dependency "sprockets-rails"
  spec.add_development_dependency "sassc"
  spec.add_development_dependency "importmap-rails"
  spec.add_development_dependency "tailwindcss-ruby"
  spec.add_development_dependency "rackup"
  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "factory_bot"
  spec.add_development_dependency "sanitize"
end
