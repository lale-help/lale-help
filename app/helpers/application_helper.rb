module ApplicationHelper
  def humanize_date(date)
    # distance_of_time_in_words Time.now, date
    date.strftime("%d %B %Y")
  end
end
