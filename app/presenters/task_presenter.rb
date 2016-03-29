class TaskPresenter < Presenter
  delegate :id, :name, :volunteers, :volunteer_count_required, :comments,  to: :object

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

  let(:due_date_long) do
    I18n.l(_.due_date, format: "%A %-d %B %Y")
  end


  let(:due_date_and_time) do
    str = due_date_long
    str = "#{str} #{scheduled_time}" if scheduled_time.present?
    str
  end

  let :scheduled_time do
    # FIXME adapt this to new date/time input
    if _.scheduling_type != 'on_date'
      I18n.t("activerecord.attributes.task.scheduled-time.#{_.scheduling_type}", start: _.start_time, end: _.due_time)
    end
  end

  let :duration_text do
    I18n.t("activerecord.attributes.task.duration-text.#{duration}")
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