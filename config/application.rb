require File.expand_path('../boot', __FILE__)

require 'rails/all'

Bundler.require(*Rails.groups)

module LaleHelp
  class Application < Rails::Application
    LaleHelp::Application.config.assets.version = '1.0'

    config.assets.precompile += %w( .svg .eot .woff .woff2 .ttf )

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{yml}').to_s]
    # config.i18n.default_locale = :de

    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.active_record.raise_in_transactional_callbacks = true

    config.mandrill_templates = !Rails.env.test?

    unless Rails.env.test?
      config.action_mailer.smtp_settings = {
        address: ENV.fetch("SMTP_ADDRESS"),
        authentication: :plain,
        domain: ENV.fetch("SMTP_DOMAIN"),
        enable_starttls_auto: true,
        password: ENV.fetch("SMTP_PASSWORD"),
        port: "587",
        user_name: ENV.fetch("SMTP_USERNAME")
      }
    end
    config.action_mailer.default_url_options = { host: ENV["SMTP_DOMAIN"] }

    config.session_expiration = 30.minutes

    config.i18n.available_locales = %w(en de fr)

    #
    # simple feature toggles using the default Rails config mechanism.
    # see http://guides.rubyonrails.org/configuring.html#custom-configuration
    #
    # Usage:
    # 1.  set new features false here and then true in the envs you want to see them
    # 1.1 use the feature_enabled?(name) wherever possible
    # 2.  when ready to go live, set toggle to true here, remove in all other environments
    # 3.  every now and then, remove toggles for stable features from the application.
    #
    config.x.feature_toggles.projects = true # added 2016-03-31 | released 2016-04-16

    config.autoload_paths += %W(
      #{config.root}/app/mutations/concerns
    )


    config.cache_store = :memory_store, { size: 64.megabytes }

    if ENV['AWS_ACCESS_KEY'].present?
      config.x.fog.storage_opts   = { provider: 'AWS', aws_access_key_id: ENV['AWS_ACCESS_KEY'], aws_secret_access_key: ENV['AWS_SECRET_KEY'], region: ENV['AWS_REGION'] }
      config.x.fog.directory_opts = { key: ENV['AWS_BUCKET'], public: false }
    else
      config.x.fog.storage_opts   = { provider: 'Local', local_root: 'tmp' }
      config.x.fog.directory_opts = { key: 'files' }
    end
  end
end

# Core Extentions
require 'formtastic/inputs/json_input'
require 'mutations/symbol_filter'
require 'serializers/secure_hash_serializer'
require 'serializers/symbol_serializer'