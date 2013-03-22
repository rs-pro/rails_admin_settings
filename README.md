# RailsAdminSettings

Note: This gem currently supports Mongoid only, as I don't need AR support.

Pull request with AR support is welcomed

## Installation

Add this line to your application's Gemfile:

    gem 'rails_admin_settings'

1) Put it after rails_admin to get built-in support
2) Put it after rails_admin_toggleable to get built-in support
3) Put it after ckeditor/glebtv-ckeditor/rich to get built-in support

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rails_admin_settings

## Basic Usage (like RailsSettings)

Settings.admin_email = 'test@example.com'
Settings.admin_email

## Advanced Usage



## Value types

Supported:

    integer (stored as string)
    string
    text
    html
    yaml

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
