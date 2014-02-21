module RailsAdminSettings
  module RailsAdminConfig
    def self.included(base)
      if base.respond_to?(:rails_admin)
        base.rails_admin do
          navigation_label I18n.t('admin.settings.label')

          list do
            if Object.const_defined?('RailsAdminToggleable')
              field :enabled, :toggle
            else
              field :enabled
            end
            field :type
            field :ns
            field :name
            field :raw do
              pretty_value do
                if bindings[:object].file_type?
                  "<a href='#{CGI::escapeHTML(bindings[:object].file.url)}'>#{CGI::escapeHTML(bindings[:object].to_path)}</a>".html_safe
                elsif bindings[:object].image_type?
                  "<a href='#{CGI::escapeHTML(bindings[:object].file.url)}'><img src='#{CGI::escapeHTML(bindings[:object].file.url)}' /></a>".html_safe
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
            field :type do
              read_only true
              help false
            end
            field :raw do
              partial "setting_value"
              visible do
                !bindings[:object].upload_type?
              end
            end
            if Settings.file_uploads_supported
              field :file, Settings.file_uploads_engine do
                visible do
                  bindings[:object].upload_type?
                end
              end
            end
          end
        end
      else
        puts "[rails_admin_settings] Problem: model does not respond to rails_admin: this should not happen"
      end
    end
  end
end
