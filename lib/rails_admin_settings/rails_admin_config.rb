module RailsAdminSettings
  module RailsAdminConfig
    def self.included(base)
      return unless defined?(::RailsAdmin)

      ::RailsAdmin.config do |config|
        config.model base do
          navigation_label I18n.t('admin.settings.label')
          list do
            if Object.const_defined?('RailsAdminToggleable')
              field :enabled, :toggle
            else
              field :enabled
            end
            field :kind
            field :ns
            field :name
            field :raw do
              pretty_value do
                object = bindings[:object]
                if object.file_kind? && !defined?(Shrine) && object.to_path.present?
                  if object.file.url.blank?
                    '-'
                  else
                    "<a href='#{CGI.escapeHTML(object.file.url)}'>#{CGI.escapeHTML(object.to_path)}</a>".html_safe
                  end
                elsif object.image_kind? && !defined?(Shrine) && !object.file.nil?
                  if object.file.url.blank?
                    '-'
                  else
                    "<a href='#{CGI.escapeHTML(object.file.url)}'><img src='#{CGI.escapeHTML(object.file.url)}' /></a>".html_safe
                  end
                else
                  value
                end
              end
            end
          end

          edit do
            field :enabled
            field :label do
              read_only true
              help false
            end
            field :kind do
              read_only true
              help false
            end
            field :raw do
              partial 'setting_value'
              visible { !bindings[:object].upload_kind? }
            end
            if Settings.file_uploads_supported
              field :file, Settings.file_uploads_engine do
                visible { bindings[:object].upload_kind? }
              end
            end
          end
        end
      end
    end
  end
end
