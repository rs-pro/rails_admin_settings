require 'spec_helper'


describe "Uploads" do
  if Settings.file_uploads_engine != :shrine
    pending "shrine not detected, skipped. To run use UPLOADS=shrine rspec"
  else
    before :each do
      f = "#{File.dirname(__FILE__)}/../uploads/1024x768.gif"
      if File.file?(f)
        File.unlink(f)
      end
    end
    it 'supports file kind' do
      Settings.set('file', File.open("#{File.dirname(__FILE__)}/support/1024x768.gif"), kind: 'file')
      expect(Settings.get(:file).file.metadata["filename"]).to eq '1024x768.gif'
      expect(Settings.get(:file).file.metadata["size"]).to eq 4357
      expect(Settings.get(:file).file.metadata["mime_type"]).to eq "image/gif"
      expect(Settings.get(:file).file.id.split(".").last).to eq "gif"
      expect(Settings.file.split("/").second + "/" + Settings.file.split("/").last.split(".").last).to eq "uploads/gif"
      expect(File.exists?("public/uploads/#{Settings.get(:file).file.id}")).to be_truthy
    end
    it 'supports image kind' do
      Settings.set('file', File.open("#{File.dirname(__FILE__)}/support/1024x768.gif"), kind: 'image')
      expect(Settings.get(:file).file.metadata["filename"]).to eq '1024x768.gif'
      expect(Settings.get(:file).file.metadata["size"]).to eq 4357
      expect(Settings.get(:file).file.metadata["mime_type"]).to eq "image/gif"
      expect(Settings.get(:file).file.id.split(".").last).to eq "gif"
      expect(Settings.file.split("/").second + "/" + Settings.file.split("/").last.split(".").last).to eq "uploads/gif"
      expect(File.exists?("public/uploads/#{Settings.get(:file).file.id}")).to be_truthy
    end
  end
end

