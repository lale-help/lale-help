#
# requires the gem action_mailer_cache_delivery
#
# cache_emails has the Rails server thread send the emails in a way that they can be accessed
# from the test thread
#
RSpec.configure do |config|

  module CachedEmailHelpers
    def last_email
      cached_emails.last
    end
    def cached_emails
      ActionMailer::Base.cached_deliveries
    end
  end

  config.include CachedEmailHelpers

  # doesn't seem to be required
  # config.before(:each) do |example|
  #   ActionMailer::Base.clear_cache
  # end
  
  config.around(:each) do |example|
    original_method = ActionMailer::Base.delivery_method
    ActionMailer::Base.delivery_method = :cache
    example.run
    ActionMailer::Base.delivery_method = original_method
  end

end