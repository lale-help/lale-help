class FileUpload::Create < Mutations::Command
  required do
    file    :file
    model   :uploadable, class: ActiveRecord::Base
    model   :uploader, class: User
    symbol  :upload_type, default: :file, in: %i(file profile_picture sponsor_logo)
    boolean :is_public
  end

  optional do
    string :name, empty: true, nils: true
  end

  def execute
    file_name = file.original_filename || File.basename(file.path)

    upload = FileUpload.new
    upload.id = SecureRandom.uuid

    upload.name        = name.present? ? name : File.basename(file_name, '.*')
    upload.upload_type = upload_type
    upload.uploadable  = uploadable
    upload.uploader    = uploader
    upload.is_public   = is_public


    encrypted = Crypto::Encryptor.new.process(file.read)

    upload.file_encryption_details = encrypted.details

    upload.file_name         = file_name
    upload.file_size_bytes   = file.size
    upload.file_path         = "file_uploads/#{upload.id}"
    upload.file_content_type = ::MIME::Types.type_for(file.path).first.to_s
    upload.file_extension    = File.extname(file.path)

    FileUpload.directory.files.create({
      :body         => encrypted.data,
      :key          => upload.file_path,
      :public       => false
    })

    upload.save!
    upload
  end
end