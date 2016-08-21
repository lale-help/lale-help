FactoryGirl.define do

  factory :file_upload do
    id                   { FileUpload.uploadable_gid(uploadable) }
    sequence(:name)      { |n| "File #{n}" }
    upload_type          'file'
    uploader             { create(:user) }
    uploadable           { create(:circle) }
    is_public            true
    sequence(:file_name) { |n| "file_name_#{n}.jpg" }
    file_path            'file_uploads/some-random-dir'
    file_content_type    'image/jpeg'
    file_extension       '.JPG'
    file_encryption_details "NUFySWJLT2c5YW10VW9EQXRmZGtxYXhUc0ZldmhJVjFTQk5sSGczZzcwbnRSZkVWUDVGM25hVWFlTFlLcEFpeVJ2WmRPQVZ4THlVMlRRNDVSVm1tZUVaM2QxQ3FCekJyM0tkR2lIYm9wSExaN0dodVJMSllFU1VkajdaeG1RTjUySDJpZWFmR05jQlhPWmtHSm1zM3l0a1FzbnlVWXdRWWduWTdtV25UN2thbElwN216YnJyRW5kWVp5Z2ltZzRpL3ZsRWI2OFhHbmtYTjdpeU96MEM2VFR0L2RQOXBwc1VjNDV1d2gybjVtV2JoODFyejVXUFVXSnltTXAxVWRjc3E2NExNQkFkQzE0bWhGWG84MWNLL2Q0QlhYRlIreDlsOGJ1NlBGb2ZIM2c9LS00NUJER1J3K3NESmFtalhrQjdTYzR3PT0=--6a1c196f527d0d5f7533bb2e4f21bff720da5525"
    file_size_bytes      4_061_593

    factory :circle_file_upload do
    end

    factory :working_group_file_upload do
        uploadable { create(:working_group) }
    end
end

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
    is_public        true
    redirect_path    { "" }
  end
end
