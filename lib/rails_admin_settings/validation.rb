module RailsAdminSettings
  module Validation
    def self.included(base)
      base.before_validation do
        self.raw = default_serializable_value if raw.blank?
      end
      base.before_validation :preprocess_value, if: :preprocessed_kind?
      base.validates_uniqueness_of :key, scope: :ns
      base.validates_inclusion_of :kind, in: RailsAdminSettings.kinds
      base.validates_numericality_of :raw, if: :integer_kind?

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

      base.validate if: :email_kind? do
        require_validates_email_format_of do
          errors.add(:raw, I18n.t('admin.settings.email_invalid')) unless raw.blank? || ValidatesEmailFormatOf.validate_email_format(raw).nil?
        end
      end

      base.validate if: :address_kind? do
        require_geocoder do
          # just raise error if we are trying to use address kind without geocoder
        end
      end

      base.validate if: :file_kind? do
        unless Settings.file_uploads_supported
          raise '[rails_admin_settings] File kind requires either CarrierWave or Paperclip. Check that rails_admin_settings is below them in Gemfile'
        end
      end

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

      if Object.const_defined?('Geocoder')
        if RailsAdminSettings.mongoid?
          base.field(:coordinates, type: Array)
          base.send(:include, Geocoder::Model::Mongoid)
        end
        base.geocoded_by(:raw)
        base.after_validation(:geocode, if: :address_kind?)
      end

      base.validates_with(RailsAdminSettings::HexColorValidator, attributes: :raw, if: :color_kind?)

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
