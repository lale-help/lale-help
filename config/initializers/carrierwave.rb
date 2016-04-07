CarrierWave.configure do |config|
  config.storage_engines[:fog_encrypted] = 'EncryptedStorage'
  config.cache_dir = "#{Rails.root}/tmp/uploads"

  # For testing, upload files to local `tmp` folder.
  if Rails.env.test? || Rails.env.cucumber?
    config.storage = :file
    config.enable_processing = false
    config.root = "#{Rails.root}/tmp"

  else
    config.storage = :fog_encrypted
    config.fog_credentials = {
      :provider              => 'AWS',
      :aws_access_key_id     => ENV['AWS_ACCESS_KEY'],
      :aws_secret_access_key => ENV['AWS_SECRET_KEY'],
      :region                => ENV['AWS_REGION']
    }
    config.fog_directory      = ENV['AWS_BUCKET']

    config.fog_public     = false
    config.fog_authenticated_url_expiration = 600
  end
end


