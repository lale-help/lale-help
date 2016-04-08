class ProjectPresenter < Presenter
  
  delegate :id, :name, :working_group, :admin, to: :object

  def description(length: nil)
    if length
      _.description.truncate(length, separator: /\s/, omission: '...')
    else
      _.description
    end
  end

  let(:start_date) do
    dates = []
    dates << _.tasks.minimum("start_date")
    # quick hack: if no task has a start date, use the earliest end date. 
    dates << _.tasks.minimum("due_date")
    dates << _.supplies.minimum("due_date")
    I18n.l(dates.compact.min, format: :long) unless dates.empty?
  end

  let(:due_date) do
    dates = []
    dates << _.tasks.maximum("due_date")
    dates << _.supplies.maximum("due_date")
    I18n.l(dates.compact.max, format: :long) unless dates.empty?
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
    _.admins.active.count
  end

end
