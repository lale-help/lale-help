Capybara.register_driver :poltergeist_debug do |app|
  Capybara::Poltergeist::Driver.new(app, inspector: true)
end

unless (ENV['SELENIUM'])
  require 'capybara/poltergeist'
  Capybara.javascript_driver = :poltergeist
  # Switch to this driver when you want to inspect the page under test with the 
  # webkit console. Insert page.driver.debug into your test & the inspector will open.
  # Capybara.javascript_driver = :poltergeist_debug
else
  # leave selenium in for now as it is sometimes useful to follow the tests clicking through the page
  Capybara.current_driver = :selenium
end

require 'capybara-screenshot/rspec'
Capybara::Screenshot.prune_strategy = :keep_last_run

# defaults to 2
Capybara.default_max_wait_time = 5

Capybara.server do |app, port|
  Rack::Handler::Unicorn.run app, Port: port
end

module CapybaraExtension
  def drag_by(right_by, down_by)
    base.drag_by(right_by, down_by)
  end
end

module CapybaraSeleniumExtension
  def drag_by(right_by, down_by)
    driver.browser.action.drag_and_drop_by(native, right_by, down_by).perform
  end
end

RSpec.configure do |config|
  module ScreenshotHelpers
    def show!
      sleep 2
      save_and_open_screenshot
    end
  end
  config.include ScreenshotHelpers
end

::Capybara::Selenium::Node.send :include, CapybaraSeleniumExtension
::Capybara::Node::Element.send :include, CapybaraExtension

Capybara.register_driver :docker_firefox do |app|
  Capybara::Selenium::Driver.new(app, {
    browser: :remote,
    url: "http://localhost:4444/wd/hub",
    desired_capabilities: Selenium::WebDriver::Remote::Capabilities.firefox
  })
end

if ENV['IsDockerContainer'] == "true"
  Capybara.current_driver = :docker_firefox
  Capybara.javascript_driver = :docker_firefox

  Capybara.app_host = "http://localhost:56555"
  Capybara.server_port = "56555"
  Capybara.server_host = '0.0.0.0'
end
