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
    render partial: 'layouts/internal/sidebar_item', locals: opts
  end

  def lale_form form, opts={}, &block
    opts[:url]    ||= form.url
    opts[:method] ||= form.method
    form_for(form, opts, &block)
  end
end
