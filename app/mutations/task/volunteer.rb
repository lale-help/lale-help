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

    if assignment.persisted?
      (task.users.uniq - [ user ]).each do |outboud_user|
        next unless outboud_user.email.present?
        changes = { volunteers: [] } # a slight hack; only the key is relevant
        TaskMailer.task_change(task, outboud_user, changes).deliver_now
      end
      Task::Comments::Base.run(task: task, message: 'user_assigned', user: user)
    else
      add_error :assignment, :failed
    end

    assignment
  end
end
