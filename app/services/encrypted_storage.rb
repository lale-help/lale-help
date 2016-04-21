class EncryptedStorage
  class Encryptor < Struct.new :details
    def process data
      self.details ||= Hash.new
      cipher         = build_cipher(details)

      encrypted        = cipher.update(data) + cipher.final
      details[:auth_tag] = cipher.auth_tag

      OpenStruct.new(data: encrypted, details: details)
    end

    private
    def build_cipher(details)
      details[:cipher] ||= 'aes-128-gcm'

      OpenSSL::Cipher.new(details[:cipher]).tap do |cipher|
        cipher.encrypt
        cipher.key       = details[:key]       ||= cipher.random_key
        cipher.iv        = details[:iv]        ||= cipher.random_iv
        cipher.auth_data = details[:auth_data] ||= SecureRandom.random_bytes(16)
      end
    end
  end


  class Decryptor < Struct.new :details
    def process data
      cipher    = build_cipher(self.details)
      decrypted = cipher.update(data) + cipher.final
      decrypted.force_encoding(Encoding::UTF_8)
      decrypted
    end

    private
    def build_cipher(details)
      OpenSSL::Cipher.new(details[:cipher]).tap do |cipher|
        cipher.decrypt
        cipher.key       = details[:key]
        cipher.iv        = details[:iv]
        cipher.auth_data = details[:auth_data]
        cipher.auth_tag  = details[:auth_tag]
      end
    end
  end


  # class File < CarrierWave::Storage::Fog::File
  #   def read
  #     @uploader.decryptor.process(file.body)
  #   end
  #
  #   def store(new_file)
  #     fog_file = new_file.to_file
  #
  #     encrypted = @uploader.encryptor.process(fog_file.read)
  #
  #     @uploader.encryption_details = encrypted.details
  #
  #     @content_type ||= new_file.content_type
  #     @file = directory.files.create({
  #       :body         => encrypted.data,
  #       :content_type => @content_type,
  #       :key          => path,
  #       :public       => @uploader.fog_public
  #     }.merge(@uploader.fog_attributes))
  #
  #     fog_file.close if fog_file && !fog_file.closed?
  #     true
  #   end
  # end
  #
  #
  # class Uploader < CarrierWave::Uploader::Base
  #   delegate :encryption_details, :encryption_details=, to: :model
  #
  #   def encryptor
  #     @encryptor ||= Encryptor.new(encryption_details)
  #   end
  #
  #
  #   def decryptor
  #     @decryptor ||= Decryptor.new(encryption_details)
  #   end
  # end
  #
  #
  # def store!(file)
  #   f = EncryptedStorage::File.new(uploader, self, uploader.store_path)
  #   f.store(file)
  #   f
  # end
  #
  # def retrieve!(identifier)
  #   EncryptedStorage::File.new(uploader, self, uploader.store_path(identifier))
  # end
end