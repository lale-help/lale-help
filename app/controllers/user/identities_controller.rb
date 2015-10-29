class User::IdentitiesController < ApplicationController
  skip_authorization_check
  layout 'circle_page'

  def new
    @identity = env['omniauth.identity'] || User::Identity.new
  end
end
