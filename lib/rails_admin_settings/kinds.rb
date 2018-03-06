module RailsAdminSettings
  def self.kinds
    [
      'string',
      'text',
      'integer',
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
      'simple_format',
      'simple_format_raw',
      'json',
    ]
  end

  def self.types
    self.kinds
  end
end
