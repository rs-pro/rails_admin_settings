ENV["MONGOID_ENV"] = "test"
Mongoid.load!("spec/support/mongoid.yml")

RSpec.configure do |configuration|
  configuration.include Mongoid::Matchers
end
