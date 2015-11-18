class Public::CirclesController < ApplicationController
  layout 'public'
  skip_authorization_check
  before_action :ensure_logged_in

  def index
    @form = Circle::Join.new user: current_user
  end

  def join
    form = Circle::Join.new params[:user], user: current_user
    outcome = form.submit()

    if outcome.success?
      redirect_to circle_path(outcome.result)
    else
      redirect_to public_circles_path
    end
  end

  def new
    @form = Circle::Create.new user: current_user
  end

  def create
    @form = Circle::Create.new params[:circle], user: current_user
    outcome = @form.submit
    if outcome.success?
      redirect_to circle_path(outcome.result)
    else
      raise
    end
  end
end