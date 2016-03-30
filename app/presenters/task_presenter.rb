class TaskPresenter < Presenter
  delegate :id, :name, :volunteers, :volunteer_count_required, :comments,  to: :object

  def description(length: nil)
    if length
      _.description.truncate(length, separator: /\s/, omission: '...')
    else
      _.description
    end
  end

  let(:statuses) do
    statuses = []
    statuses << :complete  if _.complete?
    statuses << :on_track  if on_track?
    statuses << :urgent    if more_volunteers_needed?
    statuses << :new
    statuses
  end

  let(:status) do
    statuses.first
  end

  let(:messages) do
    statuses = []
    statuses << :more_volunteers_needed if more_volunteers_needed?
    statuses << :recent_activity        if recent_comments?
    statuses
  end

  let(:message_key) { messages.first }

  let(:message) do
    I18n.t("task.presenter.messages.#{message_key}") if message_key.present?
  end

  let(:due_date) do
    I18n.l(_.due_date, format: :long)
  end

  let(:start_date_and_time) do
    if _.start_date
      str = I18n.l(_.start_date, format: "%A %-d %B %Y")
      str << " #{_.start_time}" if _.start_time.present?
      str
    end
  end

  let(:due_date_and_time) do
    str = I18n.l(_.due_date, format: "%A %-d %B %Y")
    str << " #{_.due_time}" if _.due_time.present?
    str
  end

  let(:scheduling_sentence) do
    I18n.t(_.scheduling_type, 
      scope: "activerecord.attributes.task.scheduling_sentence",
      start: start_date_and_time,
      due:   due_date_and_time
    ).html_safe
  end

  let :duration_text do
    I18n.t("activerecord.attributes.task.duration-text.#{_.duration}")
  end

  let(:on_track?) do
    _.volunteers.size >= _.volunteer_count_required
  end

  let(:more_volunteers_needed?) do
    !on_track? and _.due_date < 3.days.from_now
  end

  let(:recent_comments?) do
    _.comments.where("created_at > ?", 2.days.ago).exists?
  end

  let(:css) do
    "urgency--#{status}" if status.present?
  end

end