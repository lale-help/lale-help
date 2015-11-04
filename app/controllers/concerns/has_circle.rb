module HasCircle
  extend ActiveSupport::Concern

  included do
    layout 'internal'
    helper_method :current_circle
  end

  def current_circle
    return @circle if defined? @circle
    return unless params[:circle_id].present? || params[:id].present?

    @circle = begin
      circle_id = params[:circle_id] || params[:id]
      Circle.find(circle_id)
    end
  end
end
