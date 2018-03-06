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
    it 'supports file kind' do
      Settings.set('file', File.open("#{File.dirname(__FILE__)}/support/1024x768.gif"), kind: 'file')
      expect(Settings.get(:file).file_file_name).to eq '1024x768.gif'
      expect(Settings.get(:file).file_file_size).to eq 4357
      expect(Settings.file[0..21]).to eq '/uploads/1024x768.gif?'
      expect(File.exists?("#{File.dirname(__FILE__)}/../uploads/1024x768.gif")).to be_truthy
    end

    it 'supports image kind' do
      Settings.set('file', File.open("#{File.dirname(__FILE__)}/support/1024x768.gif"), kind: 'image')
      expect(Settings.get(:file).file_file_name).to eq '1024x768.gif'
      expect(Settings.get(:file).file_file_size).to eq 4357
      expect(Settings.file[0..21]).to eq '/uploads/1024x768.gif?'

      expect(File.exists?("#{File.dirname(__FILE__)}/../uploads/1024x768.gif")).to be_truthy
    end

    it 'supports defaults' do
      Settings.apply_defaults!(File.join(File.dirname(__FILE__), 'support/defaults_w_file.yml'))
      expect(File.exists?(Settings.root_file_path.join("uploads/1024x768.gif"))).to be_truthy
    end
  end
end

