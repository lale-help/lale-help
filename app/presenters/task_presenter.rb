class TaskPresenter < Presenter
  delegate :id, :name, :volunteers, :volunteer_count_required, :comments, :due_date, :circle, :organizer,
    :description, :complete?, :on_track?, :more_volunteers_needed?, to: :object

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
    statuses << :on_track  if _.on_track?
    statuses << :urgent    if _.more_volunteers_needed?
    statuses << :new
    statuses
  end

  let(:status) do
    statuses.first
  end

  let(:messages) do
    statuses = []
    statuses << :more_volunteers_needed if _.more_volunteers_needed?
    statuses << :recent_activity        if recent_comments?
    statuses
  end

  let(:message_key) { messages.first }

  let(:message) do
    I18n.t("task.presenter.messages.#{message_key}") if message_key.present?
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

  let(:formatted_date) do
    string = I18n.t(_.scheduling_type,
      scope: "activerecord.attributes.task.scheduling_sentence",
      start: start_date_and_time,
      due:   due_date_and_time
    )
    string.nil? ? nil : string.html_safe
  end

  let(:duration_text) do
    I18n.t(_.duration, scope: "activerecord.attributes.task.duration-text")
  end

  let(:recent_comments?) do
    _.comments.where("created_at > ?", 2.days.ago).exists?
  end

  let(:css) do
    "taskable-urgency-#{status}" if status.present?
  end

  let(:date_attributes) do
    {data: {urgency: status}} if status.present?
  end

  private

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

end
