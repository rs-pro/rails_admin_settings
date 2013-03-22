module RailsAdminSettings
  module RailsAdminConfig
    def self.included(base)
      base.rails_admin do
        navigation_label t('admin.settings.label')

        object_label_method do
          :key
        end

        list do
          if Object.const_defined?('RailsAdminToggleable')
            field :enabled, :toggle
          else
            field :enabled
          end

          field :key
          field :type
        end

        edit do
          field :enabled

          field :raw do
            partial "setting_value"
          end

          field :key do
            read_only true
          end
          field :type do
            read_only true
          end
        end
      end
    end
  end
end
