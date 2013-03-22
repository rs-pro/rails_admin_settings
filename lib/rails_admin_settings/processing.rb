module RailsAdminSettings
  module Processing
    def text_type?
      ['string', 'html', 'sanitized', 'email'].include? type
    end

    def html_type?
      ['html', 'sanitized'].include? type
    end

    def integer_type?
      'integer' == type
    end

    def yaml_type?
      'yaml' == type
    end

    def email_type?
      'email' == type
    end

    def phone_type?
      'phone' == type
    end

    def phone_type?
      'phone' == type
    end

    def value
      if raw.blank? || disabled?
        default_value
      else
        processed_value
      end
    end

    def to_s
      if yaml_type? || phone_type? || integer_type?
        raw
      else
        value
      end
    end

    private

    def sanitize_value
      require_sanitize do
        self.raw = Sanitize.clean(value, Sanitize::Config::RELAXED)
      end
    end

    def default_value
      if html_type?
        ''.html_safe
      elsif text_type?
        ''
      elsif integer_type?
        0
      elsif yaml_type?
        nil
      elsif phone_type?
        require_russian_phone do
          RussianPhone::Number.new('(000) 000-00-00')
        end
      else
        nil
      end
    end

    def process_text
      replacer = Proc.new do |m|
        if Time.now.strftime('%Y') == $1
          $1
        else
          "#{$1}-#{Time.now.strftime('%Y')}"
        end
      end

      text = raw.dup

      text.gsub!('{{year}}', Time.now.strftime('%Y'))
      text.gsub!(/\{\{year\|([\d]{4})\}\}/, &replacer)
      text = text.html_safe if html_type?
      text
    end

    def load_phone
      require_russian_phone do
        RussianPhone::Number.new(raw)
      end
    end

    def load_yaml
      require_safe_yaml do
        YAML.safe_load(raw)
      end
    end

    def processed_value
      if text_type?
        process_text
      elsif integer_type?
        raw.to_i
      elsif yaml_type?
        load_yaml
      elsif phone_type?
        load_phone
      else
        nil
      end
    end

    def self.included(base)
      base.class_eval do
        alias_method :val, :value
      end
    end
  end
end
