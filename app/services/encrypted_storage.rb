class EncryptedStorage
  class Encryptor
    def process data
      (cipher, details) = build_cipher

      encrypted          = cipher.update(data) + cipher.final
      details[:auth_tag] = cipher.auth_tag

      OpenStruct.new(data: encrypted, details: details)
    end

    private
    def build_cipher
      details = Hash.new
      details[:cipher] = 'aes-128-gcm'

      cipher = OpenSSL::Cipher.new(details[:cipher]).tap do |cipher|
        cipher.encrypt
        cipher.key       = details[:key]       = cipher.random_key
        cipher.iv        = details[:iv]        = cipher.random_iv
        cipher.auth_data = details[:auth_data] = SecureRandom.random_bytes(16)
      end

      [cipher, details]
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
end