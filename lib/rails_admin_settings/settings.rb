class Settings
  def initialize
    @settings = []
    Setting.all.each do |setting|
      @settings[setting.code] = setting
    end
  end

  def method_missing(code, *args)
    code = code.to_s

    if code[-1] == '='
      code = code[0..-2]
      options = args[1] || {}
      options[:default] = args.first
      create_setting(code, options)
    elsif @settings[code].nil?
      create_setting(code, args.first || {})
    else
      @settings[code]
    end
  end

  def save_default(code, value)
    create_setting(code, default: value) if @settings[code].nil?
  end

  def self.save_default(code, value)
    Settings.new.save_default(code, value)
  end

  def self.method_missing(code, *args)
    Settings.new.send(code, *args).to_s
  end

  def to_a
    @settings
  end

  # to statisfy rspec
  def self.to_ary
    ['Settings']
  end

  private

  def create_setting(code, options = {})
    options.symbolize_keys!
    options = {code: code, enabled: true, mode: 'html', default: '', default_2: ''}.merge(options)
    options[:content_1] = options.delete(:default)
    options[:content_2] = options.delete(:default_2)
    @settings[code] = RailsAdminSettings::Setting.find_or_create_by(code: code)
    @settings[code].update_attributes!(options)
    @settings[code]
  end
end