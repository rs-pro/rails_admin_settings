module RailsAdminSettings
  def self.kinds
    [
      'string',
      'text',
      'integer',
      'float',
      'boolean',
      'html',
      'code',
      'sanitized',
      'yaml',
      'phone',
      'phones',
      'email',
      'address',
      'file',
      'image',
      'url',
      'domain',
      'color',
      'strip_tags',
      'sanitize',
      'sanitize_code',
      'simple_format',
      'simple_format_raw',
      'json',
    ]
  end

  def self.types
    self.kinds
  end
end
