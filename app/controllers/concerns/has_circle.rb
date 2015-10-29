module HasCircle
  extend ActiveSupport::Concern

  included do
    layout 'internal'
    before_action :setup_circle_sidebar
    helper_method :current_circle
  end

  def current_circle
    return @circle if defined? @circle
    @circle = begin
      circle_id = params[:circle_id] || params[:id]
      Circle.find(circle_id)
    end
  end

  def setup_circle_sidebar
    content_for :header_left do
      render_to_string partial: 'sidebar/circle_title', locals: { circle: current_circle }
    end

    content_for :sidebar_links do
      render_to_string partial: 'sidebar/circle_links', locals: { links: sidebar_links }
    end
  end

  def sidebar_links
    [
      { name: 'Dashboard', url: circle_path(current_circle)          , class: css_class_for_link(CirclesController)},
      { name: 'Tasks',     url: circle_tasks_path(current_circle)    , class: css_class_for_link(Circle::TasksController)},
      { name: 'People',    url: circle_members_path(current_circle)  , class: css_class_for_link(Circle::MembersController)},
      { name: 'Calendar',  url: circle_calendar_path(current_circle) , class: css_class_for_link(Circle::CalendarsController)},
      { name: 'Admin',     url: circle_admin_path(current_circle)    , class: css_class_for_link(Circle::AdminsController)},
    ]
  end

  def css_class_for_link controller_class
    'selected' if controller_class == self.class
  end
end
