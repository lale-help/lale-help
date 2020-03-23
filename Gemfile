source 'https://rubygems.org'
ruby '2.5.7'

gem 'rails', '4.2.11.1' # latest Rails 4 version, released March 2019
gem 'rake'

# backend
gem 'pg'
gem 'puma'
gem 'rbsavvy_commons', git: 'https://github.com/phillipoertel/rbsavvy_commons.git', branch: 'master'
gem 'mutations'
gem 'omniauth'
gem 'omniauth-identity'
gem 'cancancan'
gem 'mandrill-api'
gem 'activeadmin', '~> 1.0.0.pre4'
gem 'migration_data'
gem 'carmen'
gem 'validate_url'

gem 'fog-aws', require: 'fog/aws'
gem 'fog-local', require: 'fog/local'

# UI
gem 'coffee-rails', '~> 4.1.0'
gem 'jquery-rails'
gem 'sass-rails', '>= 3.2'
gem 'turbolinks'
gem 'uglifier', '>= 1.3.0'
gem 'autoprefixer-rails'
gem 'slim-rails'
gem 'js-routes'
gem 'neat'
gem 'bourbon'
gem 'handlebars_assets'
gem 'font-awesome-sass'
gem "i18n-js", ">= 3.0.0.rc11"
gem 'http_accept_language'
gem 'cells-rails'
gem 'cells-slim'
gem 'rspec-cells'
gem 'actionview-encoded_mail_to' # encode email addresses in HTML to protect them from spam harvesters

# API
gem 'jbuilder', '~> 2.0'

# Other
gem 'geocoder'
gem 'timezone'
gem 'terminal-table'
gem 'country_select'
gem 'wicked_pdf'
gem 'wkhtmltopdf-binary'
gem 'sidekiq'

gem "refile", require: "refile/rails"
gem "refile-s3"
gem "refile-mini_magick"

group :development do
  gem "letter_opener_web"
  gem 'thor', require: false
  gem 'web-console', '~> 2.0'
end

group :development, :test do
  gem 'pry-rails'
  gem 'foreman', require: false
  gem 'rspec-rails'
  gem 'hologram', git: 'https://github.com/trulia/hologram.git', ref: '217548'

  gem 'capybara'
  gem 'capybara-screenshot'
  gem 'poltergeist'
  gem 'selenium-webdriver'
  gem 'database_cleaner'

  # gem 'spring'
  gem 'pry-byebug'
  gem 'pry-stack_explorer'
  gem 'awesome_print'
end

group :test do
  gem 'site_prism'
  gem 'shoulda'
  gem 'factory_girl'
  gem 'faker'
  gem 'vcr'
  gem 'webmock'
  gem 'action_mailer_cache_delivery'
  gem 'timecop'
  gem 'rspec_junit_formatter', '~> 0.2.0'
  # gem 'spring-commands-rspec'
  gem 'rspec-html-matchers'
end
