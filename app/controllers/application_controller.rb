class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  check_authorization

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, :alert => exception.message
  end

  helper_method def current_user
    @current_user ||= session[:user_id] && Volunteer.find(session[:user_id])
  end

  helper_method def current_circle
    # @current_user ||= session[:user_id] && Volunteer.find(session[:user_id])
  end

  helper_method def ensure_logged_in
    current_user || redirect_to(root_path)
  end
end
