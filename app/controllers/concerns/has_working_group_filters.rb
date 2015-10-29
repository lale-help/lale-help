module HasWorkingGroupFilters
  extend ActiveSupport::Concern

  included do
    before_action :setup_working_groups_sidebar
    helper_method :current_working_group
  end

  def setup_working_groups_sidebar
    content_for :sidebar_filters do
      render_to_string(partial: 'sidebar/working_groups_filter', locals: { circle: current_circle })
    end
  end

  def current_working_group
    return @current_working_group if defined? @current_working_group
    @current_working_group = current_circle.working_groups.find(params[:working_group]) rescue nil
  end
end

