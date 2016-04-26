class Crypto::Decryptor < Struct.new :details
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