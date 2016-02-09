class TaskPresenter < Presenter
  delegate :id, :name, :volunteers, :volunteer_count_required, :comments,  to: :object
  STATUS_MESSAGES = [:more_volunteers_needed, :comment_activity, :no_volunteers]

  let(:statuses) do
    statuses = []
    statuses << :completed if _.complete?
    statuses << :more_volunteers_needed if _.volunteers.size < _.volunteer_count_required and _.due_date < 3.days.from_now
    statuses << :comment_activity if high_comment_count
    statuses << :no_volunteers if _.volunteers.count == 0
    statuses
  end

  let(:status) do
    statuses.first
  end


  let(:urgency) do
    case status
    when :more_volunteers_needed
      :high
    when :no_volunteers, :comment_activity
      :medium
    when :completed
      :done
    else
      :on_track
    end
  end

  let(:comment_urgency) do
    if high_comment_count
      :high
    end
  end


  let(:due_date) do
    I18n.l(_.due_date, format: :long)
  end


  let(:status_message) do
    I18n.t("task.presenter.messages.#{status}") if STATUS_MESSAGES.include? status
  end


  let(:high_comment_count) do
    recent_comment_count > comment_average
  end

  let(:comment_average) do
    _.circle.comment_average
  end

  let(:recent_comment_count) do
    _.comments.where("created_at > ?", 3.days.ago).count
  end


  let(:urgency_css) do
    "urgency--#{urgency}" if urgency.present?
  end

  let(:comment_urgency_css) do
    "comment-urgency--#{comment_urgency}" if comment_urgency.present?
  end

  let(:css) do
    [urgency_css, comment_urgency_css].compact.join(" ")
  end

end