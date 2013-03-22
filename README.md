# RailsAdminSettings

Note: This gem currently supports Mongoid only, as I don't need AR support.

Pull request with AR support will be welcome

## Features

- Lazy loading - loads settings only if they are needed during request
- Loads all settings at once and caches them for the duration of request
- Supports lots of setting types - yaml, html with ckeditor, phone numbers etc

## Installation

Add this line to your application's Gemfile:

    gem 'rails_admin_settings'

## Gemfile order matters

- Put it after rails_admin to get built-in support
- Put it after rails_admin_toggleable to get built-in support
- Put it after ckeditor/glebtv-ckeditor/rich to get built-in support
- Put it after russian_phone to get built-in support
- Put it after sanitized to get built-in support
- Put it after safe_yaml to get built-in support

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rails_admin_settings

## Basic Usage (like RailsSettings)

    Settings.admin_email = 'test@example.com'
    Settings.admin_email


## Advanced Usage

    Settings.content_block_1(mode: 'html', default: 'test')
    Settings.data(mode: 'yaml')
    Settings.data = [1, 2, 3]

See more here: https://github.com/rs-pro/rails_admin_settings/blob/master/spec/advanced_usage_spec.rb

## Value types

Supported types:

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
