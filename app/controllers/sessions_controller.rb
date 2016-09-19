class SessionsController < ApplicationController
  layout 'public'
  skip_authorization_check
  skip_before_action :possibly_expire_session

  def new
    if current_user.present?
      current_user.touch :last_login
      redirect_to user_redirect_path
    else
      force_page_revalidation!
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
      redirect_to root_path, flash: {login_failed: true}
    end
  end

  def destroy
    logout
    redirect_to root_path, notice: I18n.t("sessions.destroy.signed_out")
  end

  private
  def user_redirect_path
    if session[:login_redirect].present?
      session.delete(:login_redirect)
    elsif current_user.primary_circle.present?
      current_circle = session[:circle_id] || current_user.primary_circle
      circle_path(current_circle)

    else
      public_circles_path
    end
  end

  # Tell the browser that this page should never be cached, thus forcing it to rerequest it on every visit.
  # This may fix the InvalidAuthenticityToken exceptions we get on the login form from time to time.
  # I assume the browser serves the sign in page from its local cache on some clients, and this cached
  # page's sign in form will have an expired authenticity token.
  def force_page_revalidation!
    response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
    response.headers["Pragma"] = "no-cache"
  end


end
