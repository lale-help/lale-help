FactoryGirl.define do

  factory :file_upload_form, class: FileUpload::CreateForm do
    file do
      ActionDispatch::Http::UploadedFile.new({
        tempfile: File.open('app/assets/images/avatar.jpeg'),
        filename: 'avatar.jpeg',
        type: "image/jpeg"
      })
    end

    sequence(:name)  {|n| "File #{n}" }
    uploader         { create :user }
    uploadable       { uploader }
    uploadable_gid   { FileUpload.uploadable_gid(uploadable) }
    is_public        { true }
    redirect_path    { "" }
  end
end
