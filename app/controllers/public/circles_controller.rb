class Public::CirclesController < ApplicationController
  layout 'public'
  skip_authorization_check
  before_action :ensure_logged_in
  before_action :redirect_to_circle, only: :membership_inactive

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

  def membership_inactive
    @hide_signed_in_status = true
    @user_status = current_user.role_for_circle(circle).try(:status)
    @circle = circle
  end

  private

  # when a previously pending/blocked member still has the info page open in the browser,
  # redirect to the circle.
  def redirect_to_circle
    if current_user.active_in_circle?(circle)
      redirect_to circle_path(circle)
    end
  end

  def circle
    Circle.find(params[:id] || params[:circle_id])
  end

end
