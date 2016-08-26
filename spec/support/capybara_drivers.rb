Capybara.register_driver :poltergeist_debug do |app|
  logger = Logger.new(Rails.root.join('log/poltergeist_debug.log'))
  logger.formatter = proc do |severity, datetime, progname, msg|
    "[#{datetime.strftime("%Y-%m-%d %H:%M:%S.%L")}]: #{msg}\n"
  end

  # define the #puts xmethod on _this_ instance to make it compatible; poltergeist expects an object
  # that responds to puts.
  def logger.puts(*args)
    info(*args)
  end
  # see https://github.com/teampoltergeist/poltergeist#customization for options description.
  options = { inspector: true, debug: true, logger: logger, phantomjs_logger: logger }
  Capybara::Poltergeist::Driver.new(app, options)
end

Capybara.register_driver :docker_firefox do |app|
  options = {
    browser: :remote,
    url: "http://localhost:4444/wd/hub",
    desired_capabilities: Selenium::WebDriver::Remote::Capabilities.firefox
  }
  Capybara::Selenium::Driver.new(app, options)
end

