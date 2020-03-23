class Supply::Notifications::CompletionReminderEmail < Mutations::Command
  required do
    model :supply
  end

  def execute
    [supply.volunteer].compact.each do |user|
      next unless user.email.present?
      token = Token.supply_completion.create! context: { user_id: user.id, supply_id: supply.id }
      SupplyMailer.supply_completion_reminder(supply.id, user.id, token.code).deliver_later
    end
  end
end
