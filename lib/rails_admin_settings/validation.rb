module RailsAdminSettings
  module Validation
    class << self
      def included(base)
        base.before_validation do
          self.raw = default_serializable_value if raw.blank?
        end
        base.before_validation :preprocess_value, if: :preprocessed_kind?
        base.validates_uniqueness_of :key, scope: :ns
        base.validates_inclusion_of :kind, in: RailsAdminSettings.kinds
        base.validates_numericality_of :raw, if: :integer_kind?
        base.validates_numericality_of :raw, if: :float_kind?

        add_validators(base)
      end

      def add_validators(base)
        add_color_validator(base)
        add_file_validator(base)
        add_email_validator(base)
        add_url_validator(base)
        add_phone_validator(base)
        add_geo_validator(base)
        add_yaml_validator(base)
        add_json_validator(base)
      end

      def add_color_validator(base)
        base.validates_with(RailsAdminSettings::HexColorValidator, attributes: :raw, if: :color_kind?)
      end

      def add_file_validator(base)
        base.validate if: :file_kind? do
          unless Settings.file_uploads_supported
            raise '[rails_admin_settings] File kind requires either CarrierWave or Paperclip or Shrine. Check that rails_admin_settings is below them in Gemfile'
          end
        end
      end

      def add_email_validator(base)
        base.validate if: :email_kind? do
          require_validates_email_format_of do
            errors.add(:raw, I18n.t('admin.settings.email_invalid')) unless raw.blank? || ValidatesEmailFormatOf.validate_email_format(raw).nil?
          end
        end
      end

      def add_url_validator(base)
        base.before_validation if: :url_kind? do
          require_addressable do
            self.raw = Addressable::URI.heuristic_parse(self.raw) unless self.raw.blank?
          end
        end

        base.before_validation if: :domain_kind? do
          require_addressable do
            self.raw = Addressable::URI.heuristic_parse(self.raw).host unless self.raw.blank?
          end
        end
      end

      def add_phone_validator(base)
        base.validate if: :phone_kind? do
          require_russian_phone do
            errors.add(:raw, I18n.t('admin.settings.phone_invalid')) unless raw.blank? || RussianPhone::Number.new(raw).valid?
          end
        end

        base.validate if: :phones_kind? do
          require_russian_phone do
            unless raw.blank?
              invalid_phones = raw.gsub("\r", '').split("\n").inject([]) do |memo, value|
                memo << value unless RussianPhone::Number.new(value).valid?
                memo
              end
              errors.add(:raw, I18n.t('admin.settings.phones_invalid', phones: invalid_phones * ', ')) unless invalid_phones.empty?
            end
          end
        end

      end

      def add_geo_validator(base)
        base.validate if: :address_kind? do
          require_geocoder do
            # just raise error if we are trying to use address kind without geocoder
          end
        end
        if Object.const_defined?('Geocoder')
          if RailsAdminSettings.mongoid?
            base.field(:coordinates, type: Array)
            base.send(:include, Geocoder::Model::Mongoid)
          end
          base.geocoded_by(:raw)
          base.after_validation(:geocode, if: :address_kind?)
        end
      end

      def add_yaml_validator(base)
        base.validate if: :yaml_kind? do
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

      def add_json_validator(base)
        base.validate if: :json_kind? do
          unless raw.blank?
            begin
              JSON.load(raw)
            rescue JSON::ParserError => e
              errors.add(:raw, I18n.t('admin.settings.json_invalid'))
            end
          end
        end
      end
    end
  end
end
