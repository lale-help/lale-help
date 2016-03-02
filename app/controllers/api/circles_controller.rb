class Api::CirclesController < ApplicationController
  layout false
  skip_authorization_check

  def index
    @center = params[:location].present? ? Location.location_from(params[:location]) : current_user.location
    locations = Location.near(@center).to_a
    @circles = Circle.joins(:address).where(addresses: { location_id: locations.uniq } )
  end
end