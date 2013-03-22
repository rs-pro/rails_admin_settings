module RailsAdminSettings
  module Validation
    def self.included(base)
      base.before_validation do
        self.raw = default_value if raw.blank?
      end
      base.before_validation :sanitize_value, if: :sanitized_type?
      base.validates_uniqueness_of :key
      base.validates_inclusion_of :type, in: RailsAdminSettings.types
      base.validates_numericality_of :raw, if: :integer_type?

      base.validate if: :phone_type? do
        require_russian_phone do
          errors.add(:raw, t('admin.settings.phone_invalid')) if RussianPhone::Number.new(:raw).valid?
        end
      end

      base.validate if: :email_type? do
        require_validates_email_format_of do
          errors.add(:raw, t('admin.settings.email_invalid')) unless ValidatesEmailFormatOf.validate_email_format(raw).nil?
        end
      end

      base.validate if: :yaml_type? do
        require_safe_yaml do
          unless raw.blank?
            begin
              YAML.safe_load(raw)
            rescue Psych::SyntaxError => e
              errors.add(:raw, t('admin.settings.yaml_invalid'))
            end
          end
        end
      end
    end
  end
end
