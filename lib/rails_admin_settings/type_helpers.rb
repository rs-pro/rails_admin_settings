module RailsAdminSettings
  module TypeHelpers
    def text_mode?
      ['string', 'html', 'sanitized'].include? type
    end

    def integer_mode?
      'integer' == type
    end

    def yaml_mode?
      'yaml' == type
    end

    def phone_mode?
      'phone' == type
    end

    def sanitized_mode?
      'sanitized' == type
    end
  end
end
