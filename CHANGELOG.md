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
