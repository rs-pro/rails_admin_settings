## 0.9.1

  Settings.ns(ns) now defaults to fallback to Settings.ns_fallback
  If you want an NS without fallback, specify nil:
  Settings.ns(ns, fallback: nil)

## 0.9.0

- Added ActiveRecord support
- [!!!] Type renamed to Kind to avoid messing with AR STI column

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
