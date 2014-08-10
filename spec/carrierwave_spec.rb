require 'spec_helper'

describe "Uploads" do
  if Settings.file_uploads_engine != :carrierwave
    pending "paperclip not detected, skipped. To run use UPLOADS=carrierwave rspec"
  else
    before :each do
      f = "#{File.dirname(__FILE__)}/../uploads/1024x768.gif"
      if File.file?(f)
        File.unlink(f)
      end
    end
    it 'supports file type' do
      Settings.set('file', File.open("#{File.dirname(__FILE__)}/support/1024x768.gif"), type: 'file')

      # because we're not inside Rails
      Settings.get(:file).file.root = '/'

      expect(Settings.get(:file).file.file.file).to eq "#{File.dirname(__FILE__).gsub('/spec', '/')}uploads/1024x768.gif"

      expect(File.exists?(Settings.root_file_path.join("uploads/1024x768.gif"))).to be_truthy
    end

    it 'supports image type' do
      Settings.set('file', File.open("#{File.dirname(__FILE__)}/support/1024x768.gif"), type: 'image')

      # because we're not inside Rails
      Settings.get(:file).file.root = '/'

      expect(Settings.get(:file).file.file.file).to eq "#{File.dirname(__FILE__).gsub('/spec', '/')}uploads/1024x768.gif"

      expect(File.exists?(Settings.root_file_path.join("uploads/1024x768.gif"))).to be_truthy
    end

    it 'supports defaults' do
      Settings.apply_defaults!(File.join(File.dirname(__FILE__), 'support/defaults_w_file.yml'))
      expect(File.exists?(Settings.root_file_path.join("uploads/1024x768.gif"))).to be_truthy
    end
  end
end

