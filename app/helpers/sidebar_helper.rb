# FIXME: 
# - these are global helper methods, most names are too generic.
# - move methods to separate object (presenter, view model?)
# step 1 is extracting this from template, though.
module SidebarHelper

  def user_open_tasks_counter
    current_user.tasks.for_circle(current_circle).volunteered.not_completed.count
  end

  def circle_open_tasks_counter
    current_circle.tasks.unassigned.not_completed.count.length
  end

  def supplies_counter
    current_circle.supplies.not_completed.count
  end

  def admin_actions_counter
    current_circle.pending_members.count 
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

  def sidebar_link(name, path, opts = {})
    opts[:text] = name
    opts[:path] = path
    opts[:css_selector] = "sidebar-item"
    opts[:css_selector] += " selected" if current_page?(path)
    opts[:icon_id]      ||= nil
    opts[:badge_text]   ||= nil
    render partial: 'layouts/internal/sidebar_item', locals: opts
  end
  
  private

  def working_groups_per_user(check_method)
    current_circle.working_groups.select do |wg|
      current_user.working_groups.map(&:id).send(check_method, wg.id)
    end
  end

end