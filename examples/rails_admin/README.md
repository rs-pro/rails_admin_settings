# RailsAdmin demo

From the repository root, using Ruby 4.0.7:

```sh
bundle install
bundle exec rake -f examples/rails_admin/Rakefile db:migrate db:seed
bundle exec rackup examples/rails_admin/config.ru -p 9293
```

Open http://localhost:9293/rails_admin/rails_admin_settings~setting. This app
boots only RailsAdmin. The [ActiveAdmin demo](../demo/README.md) boots only
ActiveAdmin on port 9292. Both use the same development SQLite database and
the seed and migration files under `examples/demo/db/`. Edits in either app
appear on the other app's page after reloading.
