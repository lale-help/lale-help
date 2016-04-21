class SecureHashSerializer
  def initialize key=Rails.application.secrets.secret_key_base
    @crypt = ActiveSupport::MessageEncryptor.new(key)
  end

  def load encrypted
    if encrypted.present?
      string = @crypt.decrypt_and_verify(encrypted)
      YAML.load(string)
    else
      {}
    end
  end

  def dump hash
    if hash.present?
      string = YAML.dump(hash)
      @crypt.encrypt_and_sign(string)
    end
  end
end

class FileUpload < ActiveRecord::Base
  serialize :file_encryption_details, SecureHashSerializer.new

  attr_readonly :file_name, :file_path, :file_content_type, :file_extension, :file_encryption_details, :uploadable_type, :uploadable_id

  def self.directory
    @bucket ||= begin
      storage   = Fog::Storage.new(Rails.application.config.x.fog.storage_opts)
      storage.directories.new(Rails.application.config.x.fog.directory_opts)
    end
  end

  def self.upload! file
    upload = FileUpload.new
    upload.id = SecureRandom.uuid

    encrypted = EncryptedStorage::Encryptor.new.process(file.read)

    upload.file_encryption_details = encrypted.details

    upload.file_name         = File.basename(file.path)
    upload.file_path         = "file_uploads/#{upload.id}"
    upload.file_content_type = ::MIME::Types.type_for(file.path).first.to_s
    upload.file_extension    = File.extname(file.path)

    directory.files.create({
      :body         => encrypted.data,
      :key          => upload.file_path,
      :content_type => upload.file_content_type,
      :public       => false
    })

    upload.save!
  end

  def read
    # encrypted = self.class.bucket.files.head(self.file_path).body
    encrypted = self.class.directory.files.get(self.file_path).body
    EncryptedStorage::Decryptor.new(self.file_encryption_details).process(encrypted)
  end
end
