# Be sure to restart your server when you modify this file.

expiry = Rails.env.development? ? nil : 15.minutes
Rails.application.config.session_store :cookie_store, key: '_lale_help_session', expire_after: expiry
