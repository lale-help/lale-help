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
    date = _.tasks.minimum("due_date")
    I18n.l(date, format: :long) if date
  end

  let(:due_date) do
    date = _.tasks.maximum("due_date")
    I18n.l(date, format: :long) if date
  end

  let(:has_date_range?) do
    start_date && due_date
  end

  let(:date_range_sentence) do
    I18n.t('circle.projects.show.date_range_sentence', start_date: start_date, due_date: due_date)
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
