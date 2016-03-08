module ApplicationHelper
  def humanize_date(date)
    # distance_of_time_in_words Time.now, date
    date.strftime("%d %b %Y")
  end

  def sidebar_link name, path, opts={}
    opts[:text] = name
    opts[:path] = path
    opts[:css_selector] = "sidebar-item"
    opts[:css_selector] += " selected" if current_page?(path)
    opts[:icon_id]      ||= nil
    opts[:badge_text]   ||= nil
    opts[:after_icon]   ||= nil
    render partial: 'layouts/internal/sidebar_item', locals: opts
  end

  def lale_form form, opts={}, &block
    opts[:url]    ||= form.url
    opts[:method] ||= form.method
    form_for(form, opts, &block)
  end

  # TODO: Move this to ability somehow.
  def managed_working_groups circle
    if can?(:manage, circle)
      circle.working_groups
    else
      circle.working_groups.select{|wg| can?(:manage, wg)}
    end
  end

  def circle_task_or_supply_comments_path(circle, task_supply)
    if current_task.is_a? Supply
      circle_supply_comments_path(current_circle, current_task, Comment.new)
    else
      circle_task_comments_path(current_circle, current_task, Comment.new)
    end
  end

  def working_groups_per_user(working_groups, user, check_method)
    working_groups.select{ |wg| user.working_groups.map(&:id).send(check_method, wg.id) }
  end

end
