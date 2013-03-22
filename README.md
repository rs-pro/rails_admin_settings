# RailsAdminSettings

Note: This gem currently supports Mongoid only, as I don't need AR support.

Pull request with AR support will be welcome

## Features

1) Lazy loading - loads settings only if they are needed during request
2) Loads all settings at once and caches them for the duration of request
3) Supports lots of setting types - yaml, html with ckeditor, phone numbers etc
4)

## Installation

Add this line to your application's Gemfile:

    gem 'rails_admin_settings'

1) Put it after rails_admin to get built-in support
2) Put it after rails_admin_toggleable to get built-in support
3) Put it after ckeditor/glebtv-ckeditor/rich to get built-in support
4) Put it after russian_phone to get built-in support
5) Put it after sanitized to get built-in support
6) Put it after safe_yaml to get built-in support

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rails_admin_settings

## Basic Usage (like RailsSettings)

Settings.admin_email(mode: 'string')
Settings.admin_email = 'test@example.com'
Settings.admin_email

Settings.data(mode: 'yaml')

## Advanced Usage

Please see [[here|https://github.com/rs-pro/rails_admin_settings/blob/master/spec/advanced_usage_spec.rb]]

## Value types

Supported:

    string (input)
    text (textarea)
    html (supports Rich, glebtv-ckeditor, ckeditor, but does not require any of them)
    integer (stored as string)
    yaml (requires safe_yaml)
    phone (requires russian_phone)
    sanitized (requires sanitize)

Strings and html support following replacement patterns:

    {{year}} -> current year
    {{year|2013}} -> 2013 in 2013, 2013-2014 in 2014, etc

## Usage with Rails Admin

Rails admin management for settings is supported out of the box

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
