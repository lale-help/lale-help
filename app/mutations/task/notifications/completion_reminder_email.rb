class Task::Notifications::CompletionReminderEmail < Mutations::Command
  required do
    model :task
  end

  def execute
    task.volunteers.compact.each do |user|
      next unless user.email.present?
      token = Token.task_completion.create! context: { user_id: user.id, task_id: task.id }

      TaskMailer.task_completion_reminder(task, user, token).deliver_now
    end
  end
end