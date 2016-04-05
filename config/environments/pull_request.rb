require_relative './staging'

Rails.application.configure do
  # This should probably stay empty since
  # staging + production should be the same
  # 
  # see application.rb for feature_toggle documentation
  config.x.feature_toggles.projects = true
end