class Task::Decline < Mutations::Command
  required do
    model :user
    model :task
  end

  def execute
    assignment = Task::Role.send('task.volunteer').find_by(task: task, user: user)

    return unless assignment.present?

    assignment.destroy

    (task.users.uniq - [ user ]).each do |outbound_user|
      next unless outbound_user.email.present?
      changes = { volunteers: [] } # a slight hack; only the key is relevant
      TaskMailer.task_change(task.id, outbound_user.id, changes).deliver_later
    end

    Comment::AutoComment.run(item: task, message: 'user_unassigned_self', user: user)

    assignment
  end
end
