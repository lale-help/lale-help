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
      next unless outboud_user.email.present?
      changes = { volunteers: [] } # a slight hack; only the key is relevant
      TaskMailer.task_change(task, outboud_user, changes).deliver_now
    end

    Task::Comments::Base.run(task: task, message: 'user_unassigned', user: user)

    assignment
  end
end
