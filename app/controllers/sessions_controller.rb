class SessionsController < ApplicationController
  layout 'circle_page'
  skip_authorization_check

  def new
    redirect_to(current_user.circle ? current_user.circle : new_circle_path) if current_user.present?
  end

  def create
    outcome = Authentication::VolunteerFromOmniAuth.run(env["omniauth.auth"])
    if outcome.success?
      volunteer = outcome.result
      session[:user_id] = volunteer.id

      if volunteer.circle.present?
        redirect_to volunteer.circle
      else
        redirect_to new_circle_path
      end

    else
      session.clear
      redirect_to root_path, warning: "Failed to sign in!"

    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path, notice: "Signed out!"
  end

  def failure
    redirect_to root_path, alert: "Authentication failed, please try again."
  end
end
