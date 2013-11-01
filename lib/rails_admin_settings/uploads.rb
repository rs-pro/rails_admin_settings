module RailsAdminSettings
  module Uploads
    autoload :CarrierWave, "rails_admin_settings/storage/carrierwave"

    def self.included(base)
      # carrierwave
      if base.respond_to?(:mount_uploader)
        # puts "[rails_admin_settings] CarrierWave detected"
        # base.field(:file, type: String)
        base.mount_uploader(:file, RailsAdminSettings::Uploads::CarrierWave)
        Settings.file_uploads_supported = true
        Settings.file_uploads_engine = :carrierwave
      # paperclip
      elsif Mongoid.const_defined?('Paperclip')
        base.send(:include, Mongoid::Paperclip)
        # puts "[rails_admin_settings] PaperClip detected"
        base.field(:file, type: String)
        base.has_mongoid_attached_file(:file)
        base.send(:attr_accessor, :delete_file)
        base.before_validation { self.file.clear if self.delete_file == '1' }

        Settings.file_uploads_supported = true
        Settings.file_uploads_engine = :paperclip
      else
        # puts "[rails_admin_settings] Uploads disabled"
      end
    end
  end
end

