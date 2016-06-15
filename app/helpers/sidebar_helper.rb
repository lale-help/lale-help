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

  def projects_count
    current_circle.projects.select { |project| can?(:read, project) }.count
  end

  def admin_actions_counter
    pending_admin_actions_count
  end

  def working_group_counter(working_group)
    # FIXME DRY up scopes by making methods on task, creating finder mutations/objects, etc.
    working_group.tasks.not_completed.not_in_project.count + working_group.supplies.not_completed.not_in_project.count
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
    # performance: don't load & loop through all projects if user is admin
    if (can?(:manage, current_circle) && current_circle.projects.present?)
      true
    else
      current_circle.projects.any? { |project| can?(:read, project) }
    end
  end
  
  private

  def working_groups_per_user(check_method)
    current_circle.working_groups.active.select do |wg|
      current_user.working_groups.map(&:id).send(check_method, wg.id)
    end
  end

end
