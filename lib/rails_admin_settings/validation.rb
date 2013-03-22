module RailsAdminSettings
  module Validation
    included(base) do
      alias_method :to_s, :value

      before_validation :sanitize_value if :sanitized_mode?

      validates_inclusion_of :mode, in: RailsAdminSettings.types

      validates_numericality_of :value, if: 'mode == "integer"'
      before_validation do
        self.value = 0 if mode == 'integer' and value.blank?
      end

      require_russian_phone do
        validates_with(RussianPhone::FormatValidator, fields: ['value'], if: :phone_mode?)
      end
    end
  end
end
