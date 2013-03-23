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
          errors.add(:raw, I18n.t('admin.settings.phone_invalid')) unless raw.blank? || RussianPhone::Number.new(raw).valid?
        end
      end

      base.validate if: :email_type? do
        require_validates_email_format_of do
          errors.add(:raw, I18n.t('admin.settings.email_invalid')) unless raw.blank? || ValidatesEmailFormatOf.validate_email_format(raw).nil?
        end
      end

      base.validate if: :address_type? do
        require_geocoder do
          # just raise error if we are trying to use address type without geocoder
        end
      end

      base.validate if: :file_type? do
        unless Settings.file_uploads_supported
          raise '[rails_admin_settings] File type requires either CarrierWave or Paperclip. Check that rails_admin_settings is below them in Gemfile'
        end
      end


      if Object.const_defined?('Geocoder')
        base.field(:coordinates, type: Array, default: [])
        base.send(:include, Geocoder::Model::Mongoid)
        base.geocoded_by(:raw)
        base.after_validation(:geocode, if: :address_type?)
      end

      base.validate if: :yaml_type? do
        require_safe_yaml do
          unless raw.blank?
            begin
              YAML.safe_load(raw)
            rescue Psych::SyntaxError => e
              errors.add(:raw, I18n.t('admin.settings.yaml_invalid'))
            end
          end
        end
      end
    end
  end
end
