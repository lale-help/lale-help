class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  check_authorization

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, :alert => exception.message
  end

  def current_user
    @current_user ||= session[:user_id] && Volunteer.find(session[:user_id])
  end
  helper_method :current_user

  def current_circle
    # @current_user ||= session[:user_id] && Volunteer.find(session[:user_id])
  end
  helper_method :current_circle

  def ensure_logged_in
    current_user || redirect_to(root_path)
  end
  helper_method :ensure_logged_in

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end
  before_action :set_locale
end
