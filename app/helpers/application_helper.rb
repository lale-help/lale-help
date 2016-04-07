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

  def circle_task_or_supply_comments_path(circle, task_supply)
    if current_task.is_a? Supply
      circle_supply_comments_path(current_circle, current_task, Comment.new)
    else
      circle_task_comments_path(current_circle, current_task, Comment.new)
    end
  end

  def feature_enabled?(name)
    !!Rails.configuration.x.feature_toggles.send(name)
  end
end
