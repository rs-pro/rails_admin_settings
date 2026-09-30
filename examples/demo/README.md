# RailsAdminSettings demo

From the repository root, using rbenv and Ruby 4.0.7:

```sh
bundle install
bundle exec rake -f examples/demo/Rakefile db:migrate db:seed
bundle exec rake -f examples/demo/Rakefile assets:build
bundle exec rackup examples/demo/config.ru -p 9292
```

Open http://localhost:9292/ to see settings rendered in the public page and
edit them at `/admin/rails_admin_settings_settings`. The separate
[RailsAdmin demo](../rails_admin/README.md) runs on port 9293 and uses the
same SQLite database. Reload the home page to see edits made in either app.

ActiveAdmin uses its own importmap JavaScript; the demo CSS is built with the
Ruby Tailwind CLI. No Node, npm install, or standalone JavaScript package is
needed. The public page styles are inline.
