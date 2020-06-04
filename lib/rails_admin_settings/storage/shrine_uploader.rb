module RailsAdminSettings
  module Uploads
    class ShrineUploader < Shrine
        plugin :determine_mime_type
        plugin :validation_helpers
        plugin :mongoid
        Attacher.validate do
          validate_mime_type_inclusion %w[image/jpeg image/gif image/png]
          validate_max_size 2.megabytes
        end
      end

    end
  end
