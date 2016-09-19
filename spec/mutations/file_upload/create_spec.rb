require 'rails_helper'

describe FileUpload::Create do
  before(:all) do
    FileUpload.directory.files.each { |f| f.destroy }
  end

  let(:uploaded_file) do
    ActionDispatch::Http::UploadedFile.new({
      tempfile: File.open('spec/fixtures/images/avatar.jpg'),
      filename: 'avatar.jpeg',
      type: "image/jpeg"
    })
  end

  let(:uploader) { create(:user)  }

  it "can store a file" do
    upload = FileUpload::Create.run!({
      file: uploaded_file,
      uploadable: uploader,
      uploader: uploader,
      upload_type: :file,
      is_public: false
    })

    uploaded_file.tempfile.rewind
    original_data = uploaded_file.tempfile.read

    expect(upload.read).to eq(original_data)
    expect(upload.uploader).to eq(uploader)
    expect(upload.uploadable).to eq(uploader)

    expect(FileUpload.directory.files.get(upload.file_path).body).to_not eq(original_data)
  end
end