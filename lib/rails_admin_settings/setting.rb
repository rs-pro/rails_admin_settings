# coding: utf-8
module RailsAdminSettings
  def self.modes
    ['integer', 'string', 'doublestring', 'html', 'doublehtml', 'yaml']
  end

  class Setting
    include Mongoid::Document
    include Mongoid::Timestamps::Short

    if Object.const_defined?('Mongoid') && Mongoid.const_defined?('Audit')
      include Mongoid::Audit::Trackable
      track_history track_create: true, track_destroy: true
    end

    field :enabled, type: Boolean, default: true
    scope :enabled, where(enabled: true)

    field :code, type: String
    field :mode, type: String

    field :content_1, type: String, default: ''
    field :content_2, type: String, default: ''

    validates_inclusion_of :mode, in: RailsAdminSettings.modes
    validates_numericality_of :content_1, if: 'mode == "integer"'

    def text_mode?
      ['string', 'doublestring', 'html', 'doublehtml'].include? mode
    end
    def integer_mode?
      ['integer'].include? mode
    end
    def yaml_mode?
      ['yaml'].include? mode
    end

    def process(text)
      if text_mode?
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
      elsif integer_mode?
        text.blank? ? nil : text.to_i
      elsif yaml_mode?
        text.blank? ? nil : decode_yaml(text)
      else
        nil
      end
    end

    def decode_yaml(text)
      begin
        YAML.safe_load(text)
      rescue Exception => e
        e.message << "[rails_admin_settings] Please install safe_yaml to use yaml settings"
        raise e
      end
    end

    def enabled?
      enabled
    end

    def c1
      if enabled?
        process content_1
      else
        default_value
      end
    end

    def c2
      if enabled?
        process content_2
      else
        default_value
      end
    end

    def to_s
      if enabled?
        process content_1.strip
      else
        default_value
      end
    end

    if respond_to?(:rails_admin)
      rails_admin do
        navigation_label t('admin.settings')

        object_label_method do
          :code
        end

        list do
          if Object.const_defined?('RailsAdminToggleable')
            field :enabled, :toggle
          else
            field :enabled
          end

          field :code
          field :mode
        end

        edit do
          field :enabled

          field :content_1 do
            partial "setting_value_1"
          end
          field :content_2 do
            partial "setting_value_2"
          end


          field :code do
            read_only true
          end
          field :mode do
            read_only true
          end
        end
      end
    end
  end
end