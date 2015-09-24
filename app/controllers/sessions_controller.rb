class SessionsController < ApplicationController
  layout 'circle_page'
  def new
  end

  def create
    outcome = Authentication::VolunteerFromOmniAuth.run(env["omniauth.auth"])
    session[:user_id] = outcome.result.id
    redirect_to root_url, notice: "Signed in!"
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, notice: "Signed out!"
  end

  def failure
    redirect_to root_url, alert: "Authentication failed, please try again."
  end
end