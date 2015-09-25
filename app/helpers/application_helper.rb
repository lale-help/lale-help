module ApplicationHelper
  def humanize_date(date)
    # distance_of_time_in_words Time.now, date
    date.strftime("%d %B %Y")
  end

  def classes_for_task task
    classes = []
    classes << "my-task" if task.volunteers.include?(current_user)
    classes << 'completed' if task.complete?
    classes
  end
end
