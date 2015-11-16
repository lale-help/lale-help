class Supply::Volunteer < Mutations::Command
  required do
    model :user
    model :supply
  end

  def execute
    assignment = Supply::Role.send('supply.volunteer').create(supply: supply, user: user)

    add_error :assignment, :failed unless assignment.persisted?

    assignment
  end
end