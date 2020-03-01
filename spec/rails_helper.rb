# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV['RAILS_ENV'] ||= 'test'
ENV['LOG_OUTPUT'] ||= 'log/test.log'
require File.expand_path('../../config/environment', __FILE__)

abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'rspec/rails'
require "cancan/matchers"

# Run sidekiq jobs immediately rather than queueing them, makes testing much easier.
# This can be changed per-test to test correct queueing: https://github.com/mperham/sidekiq/wiki/Testing
require 'sidekiq/testing'
Sidekiq::Testing.inline!

Dir[Rails.root.join('spec/{support}/**/*.rb')].each { |f| require f }

# load page objects
# first require files in the base directory, these are often superclasses or modules required for other pages.
Dir[Rails.root.join('spec/{page_objects}/*.rb')].each { |f| require f }
Dir[Rails.root.join('spec/{page_objects}/*/*.rb')].each { |f| require f }

ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.use_transactional_fixtures = false
  config.infer_spec_type_from_file_location!

  config.include FactoryGirl::Syntax::Methods
  config.include Rails.application.routes.url_helpers
  config.include AbstractController::Translation
  config.include MutationsHelpers

  config.filter_run focus: true
  config.run_all_when_everything_filtered = true


  config.before :suite do
    FactoryGirl.find_definitions
    DatabaseCleaner.clean_with(:truncation)
    FileUtils.rm_rf "tmp/failures"
  end

  config.around do |example|
    VCR.use_cassette("all_examples", record: :new_episodes) do
      example.run
    end
  end

  config.around(:each) do |example|
    skip "ignored on CI" if example.metadata[:ci_ignore] && ENV['CI'] == 'true'

    Rails.logger.info "-"*80
    Rails.logger.info "Starting #{example.full_description}"
    Rails.logger.tagged example.full_description do
      strategy = (example.metadata[:js] or example.metadata[:type] == :feature) ? :truncation : :transaction
      Rails.logger.info "Cleaning DB with #{strategy}"
      DatabaseCleaner.strategy = strategy
      DatabaseCleaner.cleaning do
        example.run
      end
    end
    Rails.logger.info "Finished #{example.full_description}"
    Rails.logger.info "-"*80
  end

  # The following only works for poltergeist, which I disabled temp. (unreliable in CI).
  # config.before(:each, js: true) do
  #   # feature specs need to use lale in English to find labels etc.
  #   page.driver.headers = { 'ACCEPT-LANGUAGE' => 'en' }
  # end

  config.after(:each, js: true) do |example|
    if example.exception != nil
      FileUtils.mkdir_p "tmp/failures/"
      path = "tmp/failures/#{example.full_description.tr(" ", "_")}"
      page.save_screenshot("#{path}.png")
      File.open("#{path}.html", 'w') {|f| f.write(page.html) }
    end
  end

  config.after(:suite) do
    FileUtils.rm_rf(Dir["#{Rails.root}/tmp/spec/test_files/"])
  end

  # save the status of the test runs in a file. See
  # - https://relishapp.com/rspec/rspec-core/v/3-3/docs/command-line/only-failures
  # - http://bloginius.com/blog/2015/12/28/rspec-restart-failing-tests/
  config.example_status_persistence_file_path = "#{Rails.root}/log/rspec_example_statuses.log"

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
    expectations.syntax = :expect
  end
end
