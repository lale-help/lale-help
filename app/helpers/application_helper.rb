module ApplicationHelper
  def humanize_date(date)
    # distance_of_time_in_words Time.now, date
    date.strftime("%d %b %Y")
  end
end
