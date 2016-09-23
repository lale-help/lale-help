class ProjectPresenter < Presenter

  delegate :id, :working_group, :admin, :complete?, :name, to: :object

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
    statuses << :urgent    if has_urgent_taskables?
    statuses << :new
    statuses
  end

  let(:status) do
    statuses.first
  end

  let(:css) do
    "taskable-urgency-#{status}" if status.present?
  end

  let(:start_date) do
    dates = []
    dates << _.tasks.minimum("start_date")
    # quick hack: if no task has a start date, use the earliest end date.
    dates << _.tasks.minimum("due_date")
    dates << _.supplies.minimum("due_date")
    I18n.l(dates.compact.min, format: :long) unless dates.compact.empty?
  end

  let(:due_date) do
    dates = []
    dates << _.tasks.maximum("due_date")
    dates << _.supplies.maximum("due_date")
    I18n.l(dates.compact.max, format: :long) unless dates.compact.empty?
  end

  let(:has_date_range?) do
    start_date && due_date
  end

  let(:date_range_sentence) do
    if start_date && due_date
      I18n.t('circle.projects.show.date_range_sentence', start_date: start_date, due_date: due_date)
    end
  end

  let(:tasks) do
    _.tasks.ordered_by_date
  end

  let(:supplies) do
    _.supplies.ordered_by_date
  end

  let(:admins_count) do
    _.active_admins.count
  end

  let(:stats) do
    # all this calculation is quite expensive; caching the result across requests.
    Rails.cache.fetch(cache_key_for_stats) do
      OpenStruct.new(
        tasks: OpenStruct.new(
          open:   _.tasks.incomplete.count,
          urgent: _.tasks.to_a.select { |t| t.more_volunteers_needed? }.count,
          done:   _.tasks.complete.count
        ),
        supplies: OpenStruct.new(
          open:   _.supplies.incomplete.count,
          urgent: _.supplies.to_a.select { |s| s.more_volunteers_needed? }.count,
          done:   _.supplies.complete.count
        ),
        users: OpenStruct.new(
          needed:    _.tasks.to_a.sum(&:missing_volunteer_count),
          signed_up: _.tasks.to_a.sum { |t| t.volunteers.size }
        )
      )
    end
  end

  let(:has_urgent_taskables?) do
    (stats.tasks.urgent + stats.supplies.urgent) > 0
  end

  def link_to_complete
    options = {}
    if has_incomplete_items?
      options[:onclick] = "alert(#{I18n.t('circle.projects.show.cant_complete_with_items').to_json}); return false;"
    else
      # this will submit the form anyhow even if onclick returns false, so only add it when
      # the link really should be followed.
      options[:method] = :put
    end
    context.link_to(circle_project_complete_path(_.circle, _), options) do
      yield
    end

  end

  def has_incomplete_items?
    (_.tasks.incomplete.count + _.supplies.incomplete.count) > 0
  end

  private

  # could cache more effectively if it was invalidated only on task/supply state changes
  # rather than any change, but it'll do for now.
  let(:cache_key_for_stats) do
    parts  = []
    parts << _.tasks.count.to_s
    parts << _.tasks.maximum(:updated_at).try(:utc).try(:to_i)
    parts << _.supplies.count.to_s
    parts << _.supplies.maximum(:updated_at).try(:utc).try(:to_i)
    "project-stats/#{parts.join('-')}"
  end
end
