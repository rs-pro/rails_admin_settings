module RailsAdminSettings
  module Uploads
    class CarrierWave < CarrierWave::Uploader::Base
      def extension_white_list
        %w(jpg jpeg gif png tiff psd ai txt rtf doc docx xls xlsx ppt pptx odt odx zip rar 7z pdf)
      end
    end
  end
end