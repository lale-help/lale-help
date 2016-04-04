# FIXME: move these methods to cell
module SidebarHelper

  def my_tasks_count
    current_user.tasks.for_circle(current_circle).volunteered.not_completed.count
  end

  def open_tasks_count
    current_circle.tasks.unassigned.not_completed.select { |t| can?(:read, t) }.count
  end

  def all_supplies_count
    current_circle.supplies.not_completed.select { |s| can?(:read, s) }.count
  end

  def admin_actions_counter
    pending_admin_actions_count
  end

  def working_group_counter(working_group)
    working_group.tasks.not_completed.count + working_group.supplies.not_completed.count
  end

  def current_users_working_groups
    working_groups_per_user(:include?)
  end

  def other_users_working_groups
    working_groups_per_user(:exclude?)
  end

  def sidebar_link(name, path, opts={})
    opts[:text] = name
    opts[:path] = path
    opts[:css_selector] = "sidebar-item"
    opts[:css_selector] += " selected" if current_page?(path)
    opts[:css_selector] += " #{opts[:link_class]}" if opts[:link_class].present?
    opts[:icon_id]      ||= nil
    opts[:badge_text]   ||= nil
    opts[:after_icon]   ||= nil
    opts[:id]           ||= nil
    render partial: 'layouts/internal/sidebar_item', locals: opts
  end

  def visible_projects?
    return unless feature_enabled?(:projects)
    projects = current_users_working_groups.map(&:projects).flatten
    # only show link if there are projects the user can see
    projects.count > 0 && projects.any? { |project| can?(:read, project) }
  end
  
  private

  def working_groups_per_user(check_method)
    current_circle.working_groups.select do |wg|
      current_user.working_groups.map(&:id).send(check_method, wg.id)
    end
  end

end
