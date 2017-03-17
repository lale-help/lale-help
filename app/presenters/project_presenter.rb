class ProjectPresenter < Presenter

  delegate :id, :working_group, :admin, :complete?, :name, :circle, to: :object

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

  let(:message) do
    link = context.link_to_working_group(working_group)
    I18n.t("circle.projects.show.working_group_link", link: link)
  end

  let(:start_date) do
    date = _.start_date
    I18n.l(date, format: :long) if date
  end

  let(:due_date) do
    date = _.due_date
    I18n.l(date, format: :long) if date
  end

  # please see the spec to see what's going on.
  def calendar_leaf_title_date
    today = Date.today
    if has_date_range?
      date_range = (_.start_date.._.due_date)
      if date_range.include?(today)
        today
      elsif today > date_range.last
        date_range.last
      elsif today < date_range.first
        date_range.first
      end
    else
      today
    end
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

  let(:files) do
    _.files
  end

  let(:admins_count) do
    _.active_admins.count
  end

  let(:stats) do
    # all this calculation is quite expensive; caching the result across requests.
    Rails.cache.fetch(cache_key_for_stats) do
      OpenStruct.new(
        tasks: OpenStruct.new(
          open:   _.tasks.not_completed.count,
          urgent: _.tasks.to_a.select { |t| t.more_volunteers_needed? }.count,
          done:   _.tasks.complete.count
        ),
        supplies: OpenStruct.new(
          open:   _.supplies.not_completed.count,
          urgent: _.supplies.to_a.select { |s| s.more_volunteers_needed? }.count,
          done:   _.supplies.complete.count
        ),
        users: OpenStruct.new(
          needed:    _.tasks.not_completed.to_a.sum(&:missing_volunteer_count),
          signed_up: _.tasks.not_completed.to_a.sum { |t| t.volunteers.size }
        )
      )
    end
  end

  let(:has_urgent_taskables?) do
    (stats.tasks.urgent + stats.supplies.urgent) > 0
  end

  def link_to_complete
    options = {}
    options[:method] = :put
    if has_incomplete_items?
      context.link_to(circle_project_complete_path(_.circle, _), data: {confirm: I18n.t('helpers.confirm.project.complete')}, method: 'put') do
        yield
      end
    else
      context.link_to(circle_project_complete_path(_.circle, _), options) do
        yield
      end
    end

  end

  def signed_up_volunteers_count
    stats.users.signed_up
  end

  def needed_volunteers_count
    stats.users.needed
  end

  def has_incomplete_items?
    open_taskables_count > 0
  end

  def open_taskables_count
    _.tasks.incomplete.count + _.supplies.incomplete.count
  end

  def total_taskables_count
    _.tasks.count + _.supplies.count
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
