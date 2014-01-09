# require this file to load the tasks
require 'rake'

# Require sitemap_generator at runtime. If we don't do this the ActionView helpers are included
# before the Rails environment can be loaded by other Rake tasks, which causes problems
# for those tasks when rendering using ActionView.
namespace :settings do
  # Require sitemap_generator only. When installed as a plugin the require will fail, so in
  # that case, load the environment first.
  task :require do
    Rake::Task['environment'].invoke
  end

  desc "Dump settings to config/settings.yml"
  task :dump => ['settings:require'] do
    path = Settings.root_file_path.join('config/settings.yml')
    RailsAdminSettings::Dumper.dump(path)
    puts "dumped settings to #{path}"
  end

  desc "Delete all settings"
  task :delete => ['settings:require'] do
    Settings.destroy_all!
  end
end
