class Circle::AdminsController < ApplicationController
  include HasCircle

  def show
    authorize! :manage, current_circle

    @circle_form = Circle::Update.new(user: current_user, circle: current_circle)
  end
end