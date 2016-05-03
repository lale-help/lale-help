class Public::CirclesController < ApplicationController
  layout 'public'
  skip_authorization_check
  before_action :ensure_logged_in, except: :cal
  before_action :redirect_to_circle, only: :membership_pending

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
    @form = Circle::CreateForm.new user: current_user
  end

  def create
    @form = Circle::CreateForm.new params[:circle], user: current_user
    outcome = @form.submit
    if outcome.success?
      redirect_to circle_path(outcome.result)
    else
      errors.add outcome.errors
      render :new
    end
  end

  def membership_pending
    @hide_signed_in_status = true
    @circle = circle
  end

  private

  def redirect_to_circle
    if current_user.active_in_circle?(circle)
      redirect_to circle_path(circle)
    end
  end

  def circle
    Circle.find(params[:id])
  end


end