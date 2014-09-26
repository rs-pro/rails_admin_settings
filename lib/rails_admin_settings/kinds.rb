module RailsAdminSettings
  def self.kinds
    [
      'string',
      'text',
      'integer',
      'html',
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
      'color'
    ]
  end

  def self.types
    self.kinds
  end
end