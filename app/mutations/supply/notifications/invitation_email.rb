class Supply::Notifications::InvitationEmail < Mutations::Command
  required do
    model :supply
    model :current_user, class: User
    string :type
  end

  def execute
    invitees.each do |user|
      token = Token.supply_invitation.create! context: { user_id: user.id, supply_id: supply.id }
      SupplyMailer.supply_invitation(supply.id, user.id, token.code).deliver_later
    end

    Task::Comments::Invited.run(item: supply, user: current_user, invite_count: invitees.count)

    OpenStruct.new(volunteers: invitees)
  end

  private

  def invitees
    @invitees ||= begin
      invitees = (type == "circle" ? supply.circle.volunteers.active : supply.working_group.users).to_a
      invitees.to_a.reject do |u|
        u == current_user || !u.email.present?
      end
    end
  end
end
