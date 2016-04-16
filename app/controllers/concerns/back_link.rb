module BackLink
  extend ActiveSupport::Concern

  included do
    helper_method :back_path
  end

  def set_back_path path=nil
    path ||= request.env['PATH_INFO']
    session[:back_path] = path
  end

  def back_path
    session[:back_path] || request.env['HTTP_REFERER']
  end
end