class Supply::Decline < Mutations::Command
  required do
    model :user
    model :supply
  end

  def execute
    supply = Supply::Role.send('supply.volunteer').find_by(supply: supply, user: user)
    supply.destroy if supply.present?
  end
end