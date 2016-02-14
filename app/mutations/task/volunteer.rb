class Task::Volunteer < Mutations::Command
  required do
    model :user
    model :task
  end

  def validate
    add_error(:user, :already_volunteerd) if Task::Role.send('task.volunteer').where(task: task, user: user).exists?
  end

  def execute
    assignment = Task::Role.send('task.volunteer').create(task: task, user: user)

    add_error :assignment, :failed unless assignment.persisted?

    (task.users.uniq - [ user ]).each do |outboud_user|
      TaskMailer.task_change(task, outboud_user).deliver_now
    end

    assignment
  end
end