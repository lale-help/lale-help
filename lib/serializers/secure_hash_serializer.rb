class SecureHashSerializer
  def initialize key=Rails.application.secrets.secret_key_base
    @crypt = ActiveSupport::MessageEncryptor.new(truncate_key(key))
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

  private

  # Running Ruby >= 2.4, we get an "ArgumentError: key must be 32 bytes" when trying to use the full, 128 bytes
  # long secret key base for OpenSSL::Cipher, so we need to truncate it. This is exactly what Ruby < 2.4 did before,
  # they silently discarded everything after the first 32 bytes of the key. Details here:
  # https://github.com/rails/rails/pull/25192
  def truncate_key(key)
    key[0, 32]
  end
end
