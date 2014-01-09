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

      Settings.get(:file).file.file.file.should eq "#{File.dirname(__FILE__).gsub('/spec', '/')}uploads/1024x768.gif"

      File.exists?(Settings.root_file_path.join("uploads/1024x768.gif")).should be_true
    end

    it 'supports image type' do
      Settings.set('file', File.open("#{File.dirname(__FILE__)}/support/1024x768.gif"), type: 'image')

      # because we're not inside Rails
      Settings.get(:file).file.root = '/'

      Settings.get(:file).file.file.file.should eq "#{File.dirname(__FILE__).gsub('/spec', '/')}uploads/1024x768.gif"

      File.exists?(Settings.root_file_path.join("uploads/1024x768.gif")).should be_true
    end

    it 'supports defaults' do
      Settings.apply_defaults!(File.join(File.dirname(__FILE__), 'support/defaults_w_file.yml'))
      File.exists?(Settings.root_file_path.join("uploads/1024x768.gif")).should be_true
    end
  end
end

