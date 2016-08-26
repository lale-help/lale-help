unless (ENV['SELENIUM'])
  require 'capybara/poltergeist'
  #
  # Switch to the poltergeist_debug driver when you want to inspect the page under test with the 
  # webkit console. Insert page.driver.debug into your test & the inspector will open.
  # This driver will also log the poltergeist/PhantomJS interaction as well as JS output 
  # to log/poltergeist_debug.log.
  # 
  # Capybara.javascript_driver = :poltergeist_debug
  Capybara.javascript_driver = :poltergeist
else
  # selenium is sometimes useful to watch the test using the page in the browser
  Capybara.current_driver = :selenium
end

if ENV['IsDockerContainer'] == "true"
  Capybara.current_driver = :docker_firefox
  Capybara.javascript_driver = :docker_firefox
  Capybara.app_host = "http://localhost:56555"
  Capybara.server_port = "56555"
  Capybara.server_host = '0.0.0.0'
end

# defaults to 2
Capybara.default_max_wait_time = 5

Capybara.server do |app, port|
  Rack::Handler::Unicorn.run app, Port: port
end
