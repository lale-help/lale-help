class FileUpload < ActiveRecord::Base
  serialize :file_encryption_details, SecureHashSerializer.new
  serialize :upload_type,             SymbolSerializer

  attr_readonly :file_name, :file_path, :file_content_type, :file_extension, :file_encryption_details, :uploadable_type, :uploadable_id, :uploader_id

  belongs_to :uploadable, polymorphic: true
  belongs_to :uploader,   class_name: 'User'

  def self.directory
    @bucket ||= begin
      storage   = Fog::Storage.new(Rails.application.config.x.fog.storage_opts)
      storage.directories.new(Rails.application.config.x.fog.directory_opts)
    end
  end

  def self.uploadable_gid uploadable
    Base64.strict_encode64(uploadable.to_gid.to_s)
  end

  def read
    # encrypted = self.class.bucket.files.head(self.file_path).body
    encrypted = self.class.directory.files.get(self.file_path).body
    EncryptedStorage::Decryptor.new(self.file_encryption_details).process(encrypted)
  end
end
