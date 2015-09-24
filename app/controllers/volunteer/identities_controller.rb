class Volunteer::IdentitiesController < ApplicationController
  layout 'circle_page'
  def new
    @identity = env['omniauth.identity']
  end
end