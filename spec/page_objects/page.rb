# https://robots.thoughtbot.com/better-acceptance-tests-with-page-objects
# http://martinfowler.com/bliki/PageObject.html
# https://blog.adesso.de/stabile-und-wartbare-testfaelle-fuer-selenium
# https://github.com/SeleniumHQ/selenium/wiki/PageObjects
# 
# I'm using the site prism gem for page objects:
# https://github.com/natritmeyer/site_prism
# 
# How to write page objects for feature specs:
#
# - The public methods represent the services that the page offers
# - Try not to expose the internals (HTML structure) of the page
# - Generally don't make assertions in the page object
# - when navigating from one page to another, the old page object returns an instance of the next page object
# - page objects need not represent an entire page (see also the components, which encapsulate small,
#   repeating parts of pages)s
# - Different results for the same action are modelled as different methods
# 
module PageObject
  class Page < SitePrism::Page
  end
end