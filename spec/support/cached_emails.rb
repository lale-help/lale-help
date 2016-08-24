#
# has the Rails server thread send the emails so that they can be accessed
# from the test thread
#
# requires the gem action_mailer_cache_delivery
# 
RSpec.configure do |config|

  module CachedEmailHelpers
    def last_email
      cached_emails.last
    end
    def cached_emails
      ActionMailer::Base.cached_deliveries
    end
    alias :sent_emails :cached_emails
  end

  config.include CachedEmailHelpers

  # doesn't seem to be required
  config.before(:each) do |example|
    ActionMailer::Base.clear_cache
  end
  
  config.around(:each) do |example|
    original_method = ActionMailer::Base.delivery_method
    ActionMailer::Base.delivery_method = :cache
    example.run
    ActionMailer::Base.delivery_method = original_method
  end

end