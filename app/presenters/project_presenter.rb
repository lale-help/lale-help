class ProjectPresenter < Presenter
  
  delegate :id, :name, :working_group, :admin, :admins, :members, to: :object

  def description(length: nil)
    if length
      _.description.truncate(length, separator: /\s/, omission: '...')
    else
      _.description
    end
  end

  let(:start_date) do
    _.tasks.minimum("due_date")
  end

  let(:due_date) do
    _.tasks.maximum("due_date")
  end

  let(:tasks) do
    _.tasks.not_completed.ordered_by_date
  end

  let(:supplies) do
    _.supplies.not_completed.ordered_by_date
  end

  let(:admins_count) do
    _.admins.active.count
  end

end
