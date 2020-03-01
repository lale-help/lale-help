class Task::Notifications::ReminderEmail < Mutations::Command
  required do
    model :task
  end

  def execute
    task.volunteers.compact.each do |user|
      next unless user.email.present?
      Token.task_confirmation.for_user_id(user.id).update_all(active: false)
      token    = Token.task_confirmation.create! context: { user_id: user.id, task_id: task.id }

      TaskMailer.task_reminder(task.id, user.id, token.code).deliver_later
    end
  end
end
