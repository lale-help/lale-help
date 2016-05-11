class Task::Notifications::InvitationEmail < Mutations::Command
  required do
    model :task
    model :current_user, class: User
    string :type
  end

  def execute
    invitees = volunteers.select { |user| user.email.present? }
    invitees.each do |user|
      token = Token.task_invitation.create! context: { user_id: user.id, task_id: task.id }
      TaskMailer.task_invitation(task, user, token).deliver_now
    end

    Task::Comments::Invited.run(task: task, message: 'invited', user: current_user, invite_count: invitees.count)

    OpenStruct.new(volunteers: volunteers)
  end

  private

  def volunteers
    @volunteers ||= begin
      volunteers = (type == "circle" ? task.circle.volunteers : task.working_group.users)
      volunteers.active.to_a.reject { |u| u == current_user || task.volunteers.include?(u) }
    end
  end
end
