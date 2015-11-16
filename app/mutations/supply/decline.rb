class Supply::Decline < Mutations::Command
  required do
    model :user
    model :supply
  end

  def execute
    Supply::Role.send('supply.volunteer').find_by(supply: supply, user: user).destroy
  end
end