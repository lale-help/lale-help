class SessionsController < ApplicationController
  layout 'public'
  skip_authorization_check
  skip_before_action :possibly_expire_session

  def new
    if current_user.present?
      current_user.touch :last_login
      redirect_to user_redirect_path
    else
      @show_error_message = flash.key?(:alert)
      @form = User::Login.new
    end
  end

  def create
    @form = User::Login.new params
    outcome = @form.submit
    if outcome.success?
      user = outcome.result
      user.touch :last_login
      login(user)
      redirect_to user_redirect_path

    else
      redirect_to root_path, alert: I18n.t("sessions.create.login_error_flash")
    end
  end

  def destroy
    logout
    redirect_to root_path, notice: I18n.t("sessions.destroy.signed_out")
  end

  private
  def user_redirect_path
    if session[:login_redirect].present?
      path = session[:login_redirect]
      session.delete(:login_redirect)
      path

    elsif current_user.primary_circle.present?
      circle_path(current_user.primary_circle)

    else
      public_circles_path
    end
  end

end
