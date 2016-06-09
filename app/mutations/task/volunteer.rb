class Task::Volunteer < Mutations::Command
  required do
    model :user
    model :task
  end

  def validate
    add_error(:user, :already_volunteered) if volunteer_role.exists?(task: task, user: user)
  end

  def execute
    assignment = volunteer_role.create(task: task, user: user)

    if assignment.persisted?
      #notify_users
      #create_task_comment
    else
      add_error :assignment, :failed
    end

    assignment
  end

  private

  def notify_users
    users_to_notify.each do |user|
      changes = { volunteers: [] } # a slight hack; only the key is relevant
      TaskMailer.task_assigned(task, user, changes).deliver_now
    end
    TaskMailer.task_assigned(task, user, changes).deliver_now
  end

  def create_task_comment
    Task::Comments::Assigned.run(task: task, user: user)
  end

  def users_to_notify
    (task.users.uniq - [ user ]).select { |u| u.email.present? }
  end

  def volunteer_role
    Task::Role.send('task.volunteer')
  end
end
