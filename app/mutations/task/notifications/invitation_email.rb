class Task::Notifications::InvitationEmail < Mutations::Command
  required do
    model :task
    model :current_user, class: User
    string :type
  end

  def execute
    invite_count = 0
    volunteers.each do |user|
      next unless user.email.present?
      invite_count = invite_count + 1
      token    = Token.task_invitation.create! context: { user_id: user.id, task_id: task.id }
      TaskMailer.task_invitation(task, user, token).deliver_now
    end

    Task::Comments::InviteToTaskComment.run(task: task, message: 'invited', user: current_user, invite_count: invite_count)

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
