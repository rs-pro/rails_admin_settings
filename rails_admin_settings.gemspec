# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rails_admin_settings/version'

Gem::Specification.new do |spec|
  spec.name          = "rails_admin_settings"
  spec.version       = RailsAdminSettings::VERSION
  spec.authors       = ["Gleb Tv"]
  spec.email         = ["glebtv@gmail.com"]
  spec.description   = %q{Mongoid / RailsAdmin App Settings management}
  spec.summary       = %q{Setting for Rails app with mongoid and RailsAdmin}
  spec.homepage      = "https://github.com/rs-pro/rails_admin_settings"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "mongoid", [">= 3.0", "< 5.0"]

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake", "~> 10.0.3"
  spec.add_development_dependency "rspec", "~> 2.13.0"
  spec.add_development_dependency "mongoid-rspec", "~> 1.7.0"
  spec.add_development_dependency "simplecov", "~> 0.7.1"
  spec.add_development_dependency "database_cleaner", "~> 0.9.1"
  spec.add_development_dependency "factory_girl", "~> 4.2.0"

  spec.add_development_dependency "safe_yaml", "~> 0.8.6"
  spec.add_development_dependency "russian_phone", "~> 0.3.2"
  spec.add_development_dependency "sanitize", "~> 2.0.3"
  spec.add_development_dependency "validates_email_format_of", "~> 1.5.3"
  spec.add_development_dependency "geocoder", "~> 1.1.6"
  spec.add_development_dependency "addressable", "~> 2.3.3"
end
