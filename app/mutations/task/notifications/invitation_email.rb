class Task::Notifications::InvitationEmail < Mutations::Command
  required do
    model :task
    model :current_user, class: User
    string :type
  end

  def execute
    invitees.each do |user|
      token = Token.task_invitation.create! context: { user_id: user.id, task_id: task.id }
      TaskMailer.task_invitation(task, user, token).deliver_now
    end

    Task::Comments::Invited.run(task: task, user: current_user, invite_count: invitees.count)

    OpenStruct.new(volunteers: invitees)
  end

  private

  def invitees
    @invitees ||= begin
      invitees = (type == "circle" ? task.circle.volunteers.active : task.working_group.users)
      invitees.to_a.reject do |u| 
        u == current_user || task.invitees.include?(u) || !user.email.present?
      end
    end
  end
end
