Rails.application.config.middleware.use OmniAuth::Builder do
  # provider :twitter, ENV['TWITTER_KEY'], ENV['TWITTER_SECRET']
  # provider :google_oauth2, ENV['GOOGLE_KEY'], ENV['GOOGLE_SECRET']
  # provider :facebook, ENV['FACEBOOK_ID'], ENV['FACEBOOK_SECRET']
  provider :identity,
    model: User::Identity,
    fields: [:email, :first_name, :last_name, :location, :circle_id, :commit],
    on_failed_registration: User::IdentitiesController.action(:new),
    locate_conditions: lambda{|req| {model.auth_key => req['email']} }

end

OmniAuth.configure do |config|
  config.failure_raise_out_environments = []
end