module HasCircle
  extend ActiveSupport::Concern

  included do
    layout 'internal'
    helper_method :current_circle
    before_action :save_current_circle_to_session
  end

  def save_current_circle_to_session
    session[:circle_id] = current_circle.id if current_circle.present?
  end

  def current_circle
    return @circle if defined? @circle
    return unless session[:circle_id].present? || params[:circle_id].present? || params[:id].present?

    @circle = begin
      circle_id = session[:circle_id] || params[:circle_id] || params[:id]
      Circle.find(circle_id)
    end
  end
end
