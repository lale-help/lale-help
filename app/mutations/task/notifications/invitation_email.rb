class Task::Notifications::InvitationEmail < Mutations::Command
  required do
    model :task
    model :current_user, class: User
    string :type
  end

  def execute
    volunteers.each do |user|
      next unless user.email.present?
      token    = Token.task_invitation.create! context: { user_id: user.id, task_id: task.id }
      TaskMailer.task_invitation(task, user, token).deliver_now
    end

    OpenStruct.new(volunteers: volunteers)
  end

  private

  def volunteers
    @volunteers ||= begin
      volunteers = (type == "circle" ? task.circle.volunteers.active : task.working_group.users)
      volunteers.to_a.reject { |u| u == current_user || task.volunteers.include?(u) }
    end
  end
end