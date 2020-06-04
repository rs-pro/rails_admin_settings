module RailsAdminSettings
  module Processing
    RailsAdminSettings.kinds.each do |dkind|
      define_method "#{dkind}_kind?" do
        dkind == kind
      end
      define_method "#{dkind}_type?" do
        dkind == kind
      end
    end

    def text_kind?
      (RailsAdminSettings.kinds - ['phone', 'phones', 'integer', 'float', 'yaml', 'json', 'boolean']).include? kind
    end

    def upload_kind?
      ['file', 'image'].include? kind
    end

    def html_kind?
      ['html', 'code', 'sanitize', 'sanitize_code', 'strip_tags', 'simple_format', 'simple_format_raw', 'sanitized'].include? kind
    end

    def preprocessed_kind?
      ['sanitize', 'sanitize_code', 'strip_tags', 'simple_format', 'simple_format_raw', 'sanitized'].include? kind
    end

    alias_method :text_type?, :text_kind?
    alias_method :upload_type?, :upload_kind?
    alias_method :html_type?, :html_kind?

    def value
      if upload_kind?
        unless defined?(Shrine)
          if file?
            file.url
          else
            nil
          end
        end
      elsif raw.blank? || disabled?
        default_value
      else
        processed_value
      end
    end

    def blank?
      if file_kind?
        file.url.nil?
      elsif raw.blank? || disabled?
        true
      else
        false
      end
    end

    def to_s
      if yaml_kind? || json_kind? || phone_kind? || integer_kind? || float_kind?

        raw
      else
        value
      end
    end

    private

    def preprocess_value
      case kind
        # just to raise error if not in rails
        when 'simple_format'
          require_rails do
          end
        when 'simple_format_raw'
          require_rails do
          end
        when 'strip_tags'
          require_rails do
            self.raw = ActionController::Base.helpers.strip_tags(raw)
          end
        when 'sanitize', 'sanitize_code'
          require_rails do
            self.raw = RailsAdminSettings.scrubber.sanitize(raw)
          end
        when 'sanitized'
          require_sanitize do
            self.raw = Sanitize.clean(value, Sanitize::Config::RELAXED)
          end
      end
    end

    def default_value
      if html_kind?
        ''.html_safe
      elsif text_kind?
        ''
      elsif integer_kind?
        0
      elsif float_kind?
        0
      elsif yaml_kind?
        nil
      elsif json_kind?
        nil
      elsif boolean_kind?
        false
      elsif phone_kind?
        require_russian_phone do
          RussianPhone::Number.new('')
        end
      elsif phones_kind?
        []
      else
        nil
      end
    end

    def default_serializable_value
      if phones_kind?
        ''
      elsif boolean_type?
        'false'
      else
        default_value
      end
    end

    def process_html_types(text)
      case kind
        when 'simple_format'
          require_rails do
            text = ActionController::Base.helpers.simple_format(text)
          end
        when 'simple_format_raw'
          require_rails do
            text = ActionController::Base.helpers.simple_format(text, {}, sanitize: false)
          end
      end
      text
    end

    def process_text
      text = raw.dup
      text.gsub!('{{year}}', Time.now.strftime('%Y'))
      text.gsub! /\{\{year\|([\d]{4})\}\}/ do
        if Time.now.strftime('%Y') == $1
          $1
        else
          "#{$1}-#{Time.now.strftime('%Y')}"
        end
      end
      text = process_html_types(text)
      text = text.html_safe if html_kind?
      text
    end

    def load_phone
      require_russian_phone do
        RussianPhone::Number.new(raw)
      end
    end

    def load_phones
      require_russian_phone do
        raw.gsub("\r", '').split("\n").map{|i| RussianPhone::Number.new(i)}
      end
    end

    def load_yaml
      if defined?(Psych) && Psych.respond_to?(:safe_load)
        Psych.safe_load(raw)
      else
        require_safe_yaml do
          YAML.safe_load(raw)
        end
      end
    end

    def load_json
      JSON.load(raw)
    end

    def processed_value
      if text_kind?
        process_text
      elsif integer_kind?
        raw.to_i
      elsif float_kind?
        raw.to_f
      elsif yaml_kind?
        load_yaml
      elsif json_kind?
        load_json
      elsif boolean_kind?
        raw == 'true'
      elsif phone_kind?
        load_phone
      elsif phones_kind?
        load_phones
      elsif file_kind?
        file.url
      else
        puts "[rails_admin_settings] Unknown field kind: #{kind}"
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
