module RailsAdminSettings
  module ActiveAdminDSL
    # Use inside `ActiveAdmin.register RailsAdminSettings::Setting`.
    # Settings are created by application code; administrators edit existing values.
    def rails_admin_settings
      permit_params :raw, :enabled, :file
      actions :index, :show, :edit, :update
      config.comments = false

      index do
        column :ns
        column :key
        column :label
        column :kind
        column :enabled
        column :raw, sortable: false
        actions
      end

      filter :ns
      filter :key
      filter :label
      filter :kind
      filter :enabled

      form do |f|
        f.inputs do
          f.input :ns, input_html: { disabled: true }
          f.input :key, input_html: { disabled: true }
          f.input :label, input_html: { disabled: true }
          f.input :kind, input_html: { disabled: true }
          f.input :enabled
          f.input :raw, as: :text, input_html: { rows: 6 } unless f.object.upload_kind?
          f.input :file if f.object.upload_kind? && Settings.file_uploads_supported
        end
        f.actions
      end
    end
  end
end
