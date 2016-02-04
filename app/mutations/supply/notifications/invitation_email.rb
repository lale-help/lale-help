class Supply::Notifications::InvitationEmail < Mutations::Command
  required do
    model :supply
    model :current_user, class: User
    string :type
  end

  def execute
    volunteers = (type == "circle" ? supply.circle.volunteers : supply.working_group.users).to_a

    volunteers.reject! { |u| u == current_user }

    volunteers.each do |user|
      token = Token.supply_invitation.create! context: { user_id: user.id, supply_id: supply.id }
      SupplyMailer.supply_invitation(supply, user, token).deliver_now
    end

    OpenStruct.new(volunteers: volunteers)
  end
end