class EncryptedStorage < CarrierWave::Storage::Fog
  class Encryptor < Struct.new :key, :iv, :auth_data
    def process data
      cipher    = build_cipher
      encrypted = cipher.update(data) + cipher.final
      OpenStruct.new(cipher: cipher, data: encrypted)
    end

    private
    def build_cipher
      OpenSSL::Cipher.new('aes-128-gcm').tap do |cipher|
        cipher.encrypt
        cipher.key       = key       || cipher.random_key
        cipher.iv        = iv        || cipher.random_iv
        cipher.auth_data = auth_data || ""
      end
    end
  end

  class Decryptor < Struct.new :key, :iv, :auth_data, :auth_tag
    def process data
      cipher    = build_cipher
      decrypted = cipher.update(data) + cipher.final
      decrypted.force_encoding(Encoding::UTF_8)
      decrypted
    end

    private
    def build_cipher
      OpenSSL::Cipher.new('aes-128-gcm').tap do |cipher|
        cipher.decrypt
        cipher.key       = key       || cipher.random_key
        cipher.iv        = iv        || cipher.random_iv
        cipher.auth_data = auth_data || ""
        cipher.auth_tag  = auth_tag
      end
    end
  end


  def store!(file)
    f = EncryptedStorage::File.new(uploader, self, uploader.store_path)
    f.store(file)
    f
  end

  def retrieve!(identifier)
    EncryptedStorage::File.new(uploader, self, uploader.store_path(identifier))
  end


  class File < CarrierWave::Storage::Fog::File
    def read
      @uploader.decryptor.process(file.body)
    end

    def store(new_file)
      fog_file = new_file.to_file

      encrypted = @uploader.encryptor.process(fog_file.read)

      @uploader.auth_tag = encrypted.cipher.auth_tag

      @content_type ||= new_file.content_type
      @file = directory.files.create({
        :body         => encrypted.data,
        :content_type => @content_type,
        :key          => path,
        :public       => @uploader.fog_public
      }.merge(@uploader.fog_attributes))
      fog_file.close if fog_file && !fog_file.closed?
      true
    end
  end


  class Uploader < CarrierWave::Uploader::Base
    attr_accessor :key, :iv, :auth_data, :auth_tag

    def initialize *args
      super *args

      self.key       = Rails.application.secrets.secret_key_base
      self.iv        = Rails.application.secrets.secret_key_base
      self.auth_data = Rails.application.secrets.secret_key_base
    end

    def encryptor
      @encryptor ||= Encryptor.new(key, iv, auth_data)
    end


    def decryptor
      @decryptor ||= Decryptor.new(key, iv, auth_data, auth_tag)
    end
  end
end