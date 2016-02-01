class Task::Notifications::InvitationEmail < Mutations::Command
  required do
    model :task
    model :current_user, class: User
    string :type
  end

  def execute
    volunteers = (type == "circle" ? task.circle.volunteers : task.working_group.users).to_a

    volunteers.reject! { |u| u == current_user || task.volunteers.include?(u) }

    volunteers.each do |user|
      token    = Token.task_invitation.create! context: { user_id: user.id, task_id: task.id }
      TaskMailer.task_invitation(task, user, token).deliver_now
    end
  end
end