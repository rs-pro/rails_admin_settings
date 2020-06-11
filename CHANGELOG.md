## 1.6.0 (2020-06-11)

Add shrine file uploads

## 1.5.0 (2018-06-09)

Add float type

## 1.4.1 (2018-03-07)

Fix activerecord + paperclip uploads
Minor code cleanup

## 1.4.0

Add new kinds

strip_tags (uses strip_tags rails helper)
simple_format (uses simple_format rails helper)
simple_format_raw (does NOT sanitize (allows ANY javascript) - uses simple_format rails helper with sanitize: false)
json

Use Psych.safe_load for yaml if available

## 1.3.1

add pt-BR locale (thanks @prem-prakash)

## 1.1.3

- Fix for namespace tabs when database table does not exist yet.

## 1.1.2

- Add namespace tabs in rails_admin
- Add code type with codemirror (requires glebtv-ckeditor)
- Fixed Paperclip installation checking #6. Thx @tanelj
- Add boolean data type #2. Thx @teonimesic

## 1.1.0

- Fix file type

## 1.0.0

- Support ActiveRecord

## 1.0.0.pre.1

Disable auto migrate. To migrate from 0.8 run:

```
RailsAdminSettings.migrate!
```

## 0.9.1

  Settings.ns(ns) now defaults to fallback to Settings.ns_fallback
  If you want an NS without fallback, specify nil:
  Settings.ns(ns, fallback: nil)

## 0.9.0

- Added ActiveRecord support
- [!!!] Type renamed to Kind to avoid messing with AR STI column

Rename it in all invocations, then run migrate DB with:

    RailsAdminSettings.migrate!

## 0.6.0

- Added namespaced settings
- Added loading of default settings from config/settings.yml
- Settings.label(key) is removed
- Added Settings.apply_defaults! to load settings from yml file without
  overwriting current settings.
  *note*: If setting type is changed and old value does not pass validation for
  new type, value will be reset to nil.
- Added rake settings:save_defaults to dump current settings to
  config/defaults.yml
