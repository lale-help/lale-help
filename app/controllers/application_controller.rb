class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  # check_authorization

  rescue_from CanCan::AccessDenied do |exception|
    puts current_user.inspect
    puts "HERE!!!! #{exception.action} #{exception.subject}"
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
    I18n.locale = params[:locale] || I18n.default_locale
  end
  before_action :set_locale

  def login user
    session[:user_id] = user.id
  end

  def logout
    session.clear
  end

  # # Helpers for allowing controllers to call #content_for
  def view_context
    super.tap do |view|
      (@_content_for || {}).each do |name,content|
        view.content_for name, content
      end
    end
  end

  def content_for(name, content=nil) # no blocks allowed yet
    @_content_for ||= {}
    if @_content_for[name].respond_to?(:<<)
      @_content_for[name] << content || yield
    else
      @_content_for[name] = content || yield
    end
  end
  def content_for?(name)
    @_content_for[name].present?
  end


  helper_method def filter_present?
    params.has_key? :working_group
  end
end
