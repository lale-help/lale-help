class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  check_authorization :unless => :active_admin_controller?

  rescue_from CanCan::AccessDenied do |exception|
    puts "access denied due to #{exception.inspect}"
    redirect_to root_path, :alert => exception.message
  end

  def current_user
    @current_user ||= session[:user_id] && User.find(session[:user_id])
  end
  helper_method :current_user


  def ensure_logged_in
    current_user || redirect_to(root_path)
  end
  helper_method :ensure_logged_in

  def set_locale
    I18n.locale = if params[:locale].present?
      params[:locale]
    elsif current_user.present?
      current_user.language
    else
     I18n.default_locale
   end
   logger.info "Using locale #{I18n.locale}"
  end
  before_action :set_locale

  def login user
    session[:user_id] = user.id
  end

  def logout
    session.clear
  end

  def authenticate_admin_user!
    redirect_to root_path unless (current_user and current_user.is_admin?)
  end

  helper_method def filter_present?
    params.has_key? :working_group
  end

  helper_method def errors
    @errors ||= Errors.new
  end

  private
  def active_admin_controller?
    controller_path.starts_with? "admin/"
  end

end
