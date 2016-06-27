class Supply::Volunteer < Mutations::Command
  required do
    model :user
    model :supply
  end

  def execute
    assignment = Supply::Role.send('supply.volunteer').create(supply: supply, user: user)

    if assignment.persisted?
      Task::Comments::Base.run(task: supply, message: 'user_assigned', user: user)
    else
      add_error :assignment, :failed
    end

    assignment
  end
end
