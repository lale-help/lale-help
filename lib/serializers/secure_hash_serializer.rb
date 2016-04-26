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