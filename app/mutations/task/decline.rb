class Task::Decline < Mutations::Command
  required do
    model :user
    model :task
  end

  def execute
    assignment = Task::Role.send('task.volunteer').find_by(task: task, user: user)

    return unless assignment.present?

    assignment.destroy

    (task.users.uniq - [ user ]).each do |outboud_user|
      TaskMailer.task_change(task, outboud_user).deliver_now
    end

    assignment
  end
end