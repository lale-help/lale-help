class Circle::InviteFlowController < ApplicationController
  skip_authorization_check
  layout 'public'

  def join
    form
  end

  def submit
    outcome = if current_user.present?
      Circle::Join.run(user: current_user, circle_id: circle.id)
    else
      form.submit
    end

    if outcome.success?
      login(outcome.result) unless current_user
      redirect_to circle_path(circle)

    else
      errors.add outcome.errors
      render :join
    end
  end

  helper_method def form
    @form ||= User::Create.new(params[:user] || {}, circle: circle)
  end

  helper_method def circle
    @circle ||= Circle.find_by(id: params[:circle_id])
  end
  alias_method :current_circle, :circle

  before_action do
    redirect_to root_url unless circle.present?
  end
end