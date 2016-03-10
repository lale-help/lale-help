module ApplicationHelper
  def humanize_date(date)
    # distance_of_time_in_words Time.now, date
    date.strftime("%d %b %Y")
  end

  def lale_form(form, opts={}, &block)
    opts[:url]    ||= form.url
    opts[:method] ||= form.method
    form_for(form, opts, &block)
  end

  # TODO: Move this to ability somehow.
  def managed_working_groups(circle)
    if can?(:manage, circle)
      circle.working_groups.asc_order
    else
      circle.working_groups.asc_order.select{|wg| can?(:manage, wg)}
    end
  end

  def circle_task_or_supply_comments_path(circle, task_supply)
    if current_task.is_a? Supply
      circle_supply_comments_path(current_circle, current_task, Comment.new)
    else
      circle_task_comments_path(current_circle, current_task, Comment.new)
    end
  end

end
