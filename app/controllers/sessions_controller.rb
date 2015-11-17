class SessionsController < ApplicationController
  layout 'public'
  skip_authorization_check

  def new
    redirect_to(current_user.primary_circle.present? ? circle_path(current_user.primary_circle) : new_circle_path) if current_user.present?
  end

  def create
    outcome = Authentication::UserFromOmniAuth.run(env["omniauth.auth"])
    if outcome.success?
      user = outcome.result
      login(user)

      if user.circles.present?
        redirect_to user.circles.first
      else
        redirect_to new_circle_path
      end

    else
      session.clear
      redirect_to root_path, warning: "Failed to sign in!"

    end
  end

  def destroy
    logout
    redirect_to root_path, notice: "Signed out!"
  end

  def failure
    redirect_to root_path, alert: "Authentication failed, please try again."
  end
end
