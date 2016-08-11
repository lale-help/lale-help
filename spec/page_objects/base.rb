# https://robots.thoughtbot.com/better-acceptance-tests-with-page-objects
# http://martinfowler.com/bliki/PageObject.html
# https://blog.adesso.de/stabile-und-wartbare-testfaelle-fuer-selenium
# https://github.com/SeleniumHQ/selenium/wiki/PageObjects
#
# Summary
#
# - The public methods represent the services that the page offers
# - Try not to expose the internals of the page
# - Generally don't make assertions
# - Methods return other PageObjects
# - Need not represent an entire page
# - Different results for the same action are modelled as different methods
# 
module PageObject
  class Base

    include Capybara::DSL

  end
end