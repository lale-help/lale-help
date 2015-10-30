class Task::Volunteer < Mutations::Command
  required do
    model :user
    model :task
  end

  def execute
    assignment = Task::Role.send('task.volunteer').create(task: task, user: user)

    add_error :assignment, :failed unless assignment.persisted?

    assignment
  end
end