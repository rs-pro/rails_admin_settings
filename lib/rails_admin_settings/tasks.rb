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

  desc "Dump settings to config/settings.yml; use rake settings:dump[production] to create env-specific template"
  task :dump, [:as_env] => ['settings:require'] do |t, args|
    if args.empty? || args[:as_env].blank?
      path = Settings.root_file_path.join('config/settings.yml')
    else
      path = Settings.root_file_path.join("config/settings.#{args[:as_env]}.yml")
    end
    RailsAdminSettings::Dumper.dump(path)
    puts "dumped settings to #{path}"
  end

  desc "Load settings from config/settings.yml without overwriting current values"
  task :load => ['settings:require'] do
    Settings.apply_defaults!(Rails.root.join("config/settings.#{Rails.env.to_s}.yml"), true)
    Settings.apply_defaults!(Rails.root.join('config/settings.yml'), true)
  end

  desc "Delete all settings"
  task :delete => ['settings:require'] do
    Settings.destroy_all!
  end
end
