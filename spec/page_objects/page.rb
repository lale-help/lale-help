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
#   repeating parts of pages)
# - Different results for the same action are modelled as different methods
# - start your test on the page you want to test, do not write specs that navigate to a page from the login.
#   If in doubt, write *one* navigational test that only navigates to the page you're interested in from the home page.
# - always use the ?as=admin.id hack (backdoor) to skip the sign in form. There are dedicated sign in tests that ensure login works.
#
module PageObject
  class Page < SitePrism::Page

    def load_for(resource, as:)
      # returns 'task_id' for a task instance
      resource_param_name = "#{resource.class.table_name.singularize}_id".to_sym
      params = {
        circle_id: resource.circle.id,
        resource_param_name => resource.id,
        as: as.id
      }
      load(params)
    end

    def has_flash?(message)
      find('.flash-message', text: message)
    end

    def has_comment?(message)
      find('.comment-text', text: message)
    end
  end
end