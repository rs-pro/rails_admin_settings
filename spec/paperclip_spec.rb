require 'spec_helper'


describe "Uploads" do
  if Settings.file_uploads_engine != :paperclip
    pending "paperclip not detected, skipped. To run use UPLOADS=paperclip rspec"
  else
    Paperclip.options[:log] = false
    before :each do
      f = "#{File.dirname(__FILE__)}/../uploads/1024x768.gif"
      if File.file?(f)
        File.unlink(f)
      end
    end
    it 'supports file type' do
      Settings.set('file', File.open("#{File.dirname(__FILE__)}/support/1024x768.gif"), type: 'file')
      Settings.get(:file).file_file_name.should eq '1024x768.gif'
      Settings.get(:file).file_file_size.should eq 4357
      Settings.file[0..21].should eq '/uploads/1024x768.gif?'

      File.exists?("#{File.dirname(__FILE__)}/../uploads/1024x768.gif").should be_true
    end

    it 'supports image type' do
      Settings.set('file', File.open("#{File.dirname(__FILE__)}/support/1024x768.gif"), type: 'image')
      Settings.get(:file).file_file_name.should eq '1024x768.gif'
      Settings.get(:file).file_file_size.should eq 4357
      Settings.file[0..21].should eq '/uploads/1024x768.gif?'

      File.exists?("#{File.dirname(__FILE__)}/../uploads/1024x768.gif").should be_true
    end

    it 'supports defaults' do
      Settings.apply_defaults!(File.join(File.dirname(__FILE__), 'support/defaults_w_file.yml'))
      File.exists?(Settings.root_file_path.join("uploads/1024x768.gif")).should be_true
    end
  end
end

