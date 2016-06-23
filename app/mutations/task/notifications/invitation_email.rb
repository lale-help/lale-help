class Task::Notifications::InvitationEmail < Mutations::Command
  required do
    model :task
    model :current_user, class: User
    string :type
  end

  def execute

    invite_users
    if invitees.count > 0
      Task::Comments::Invited.run(item: task, user: current_user, invite_count: invitees.count)
    end

    OpenStruct.new(volunteers: invitees)
  end

  private

  def invite_users
    invitees.each do |user|
      token = Token.task_invitation.create! context: { user_id: user.id, task_id: task.id }
      TaskMailer.task_invitation(task, user, token).deliver_now
    end
  end

  def invitees
    @invitees ||= begin
      invitees = (type == "circle" ? task.circle.volunteers.active : task.working_group.users)
      invitees.to_a.reject do |u| 
        u == current_user || task.volunteers.include?(u) || !u.email.present?
      end
    end
  end
end
