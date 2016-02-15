class Supply::Decline < Mutations::Command
  required do
    model :user
    model :supply
  end

  def execute
    assignment = Supply::Role.send('supply.volunteer').find_by(supply: supply, user: user)
    assignment.destroy if assignment.present?
  end
end