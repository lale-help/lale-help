require 'capybara-screenshot/rspec'
Capybara::Screenshot.prune_strategy = :keep_last_run

RSpec.configure do |config|
  module ScreenshotHelpers
    def show!
      sleep 2
      save_and_open_screenshot
    end
  end
  config.include ScreenshotHelpers
end
