class ApplicationController < ActionController::Base
  include SessionProtection
  include DatabaseTransactions
  include BackLink

  protect_from_forgery with: :exception
  check_authorization :unless => :active_admin_controller?
  before_action :permit_all_params, if: :active_admin_controller?
  before_action :possibly_expire_session, if: :current_user
  before_action EnsureActiveUser


  rescue_from ::CanCan::AccessDenied do |exception|
    logger.error "access denied due to #{exception.inspect}"
    redirect_to root_path, :alert => exception.message
  end

  def current_user
    @current_user ||= session[:user_id] && ::User.find(session[:user_id])
  end
  helper_method :current_user

  def current_session_circle_id
    session[:circle_id] || current_user.primary_circle.id
  end
  helper_method :current_session_circle_id

  def ensure_logged_in
    redirect_to(root_path) unless current_user.present?
  end

  def ensure_circle
    redirect_to(root_path) unless current_circle.present?
  end

  def set_locale
    accept_header_lang = http_accept_language.compatible_language_from(I18n.available_locales)

    I18n.locale = if Rails.env.test?
      :en
    elsif params[:lang].present?
      params[:lang]
    elsif current_user.present?
      current_user.language
    elsif respond_to?(:current_circle) && current_circle.present?
      current_circle.language
    elsif accept_header_lang.present?
      accept_header_lang
    else
      I18n.default_locale
    end
  end
  before_action :set_locale

  def login user
    session[:user_id] = user.id
    update_session_expiration
  end

  def logout
    session.clear
  end

  def authenticate_admin_user!
    redirect_to root_path unless (current_user and current_user.is_admin?)
  end

  # quick fix for production until we clarify which sponsor should be shown
  def current_circle_sponsor
    nil
  end
  helper_method :current_circle_sponsor

  helper_method def filter_present?
    params.has_key? :working_group
  end

  helper_method def errors
    @errors ||= ::Errors.new
  end

  private

  def active_admin_controller?
    controller_path.starts_with? "admin/"
  end

  def permit_all_params
    params.permit! # allow all parameters
  end
end
