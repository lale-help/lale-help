module SessionProtection
  extend ActiveSupport::Concern

  def possibly_expire_session
    if session[:expires_at].blank? || session[:expires_at] < Time.current
      session.clear
      redirect_to root_path

    else
      update_session_expiration
    end
  end

  def update_session_expiration
    session[:expires_at] = Time.current + Rails.application.config.session_expiration
  end

end