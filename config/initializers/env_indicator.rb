git_sha = (ENV['HEROKU_SLUG_COMMIT'] || `git rev-parse --short HEAD`)[0..6]
env_tag = "#{Rails.env}-#{git_sha}"
Rails.application.config.env_indicator = env_tag
