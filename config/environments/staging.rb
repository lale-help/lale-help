require_relative './production'

Rails.application.configure do
  # This should probably stay empty since
  # staging + production should be the same

  config.i18n.fallbacks = false
end