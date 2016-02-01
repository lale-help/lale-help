class Supply::Notifications::CompletionReminderEmail < Mutations::Command
  required do
    model :supply
  end

  def execute
    [supply.volunteer].each do |user|
      token = Token.supply_completion.create! context: { user_id: user.id, supply_id: supply.id }
      SupplyMailer.supply_completion_reminder(supply, user, token).deliver_now
    end
  end
end