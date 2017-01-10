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

  def circle_commentable_item_comment_path(circle, commentable_item, comment)
    if commentable_item.is_a? Supply
      circle_supply_comment_path(circle, commentable_item, comment)
    elsif commentable_item.is_a? Task
      circle_task_comment_path(circle, commentable_item, comment)
    elsif commentable_item.is_a? Project
      circle_project_comment_path(circle, commentable_item, comment)
    else
      nil
    end
  end

  def feature_enabled?(name)
    !!Rails.configuration.x.feature_toggles.send(name)
  end

  def link_to_back
    link_to t('.back'), back_path, class: 'back'
  end

  def html_body_attributes
    {
      data: {
        controller: controller_path,
        action:     action_name,
        'ga-id':    Rails.application.config.x.google_analytics_id
      }
    }
  end

end
