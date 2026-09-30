require "bundler/gem_tasks"

require 'rspec/core/rake_task'

desc 'Default: run specs.'
task :default => [:spec, :rails_admin_spec]

desc "Run specs"
RSpec::Core::RakeTask.new do |task|
  task.pattern = 'spec/system/**/*_spec.rb'
end

RSpec::Core::RakeTask.new(:rails_admin_spec) do |task|
  task.pattern = 'spec/rails_admin/**/*_spec.rb'
end
