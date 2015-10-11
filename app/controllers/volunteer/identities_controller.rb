class Volunteer::IdentitiesController < ApplicationController
  skip_authorization_check
  layout 'circle_page'

  def new
    @identity = env['omniauth.identity'] || Volunteer::Identity.new
  end
end
