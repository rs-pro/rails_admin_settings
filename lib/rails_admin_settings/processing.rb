module RailsAdminSettings
  module Processing
    def sanitize_value
      require_sanitize do
        self.value = Sanitize.clean(value, Sanitize::Config::RELAXED)
      end
    end

    def default_value
      if text_mode?
        ''
      elsif integer_mode?
        0
      elsif yaml_mode?
        nil
      elsif phone_mode?
        require_russian_phone do
          RussianPhone::Number.new('(000) 000-00-00')
        end
      else
        nil
      end
    end

    def process(text)
      if text_mode?
        if text.blank? || disabled?
          default_value
        else
          text = text.dup
          text.gsub!('{{year}}', Time.now.strftime('%Y'))
          replacer = Proc.new do |m|
            if Time.now.strftime('%Y') == $1
              $1
            else
              "#{$1}-#{Time.now.strftime('%Y')}"
            end
          end
          text.gsub!(/\{\{year\|([\d]{4})\}\}/, &replacer)
          text
        end
      elsif integer_mode?
        (text.blank? || disabled?) ? default_value : text.to_i
      elsif yaml_mode?
        (text.blank? || disabled?) ? default_value : load_yaml(text)
      elsif phone_mode?
        (text.blank? || disabled?) ? default_value : load_phone(text)
      else
        default_value
      end
    end

    def load_phone(text)
      require_russian_phone do
        RussianPhone::Number.new(text)
      end
    end

    def load_yaml(text)
      require_safe_yaml do
        YAML.safe_load(text)
      end
    end

    def value
      process value
    end
  end
end
