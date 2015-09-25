class SessionsController < ApplicationController
  layout 'circle_page'

  def new
  end

  def create
    outcome = Authentication::VolunteerFromOmniAuth.run(env["omniauth.auth"])
    if outcome.success?
      volunteer = outcome.result
      session[:user_id] = volunteer.id
      if volunteer.circle.present?
        redirect_to [volunteer.circle, Task]
      else
        redirect_to new_circle_path
      end

    else
      session.clear
      redirect_to root_url, warning: "Failed to sign in!"

    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, notice: "Signed out!"
  end

  def failure
    redirect_to root_url, alert: "Authentication failed, please try again."
  end
end