class Task::Decline < Mutations::Command
  required do
    model :user
    model :task
  end

  def execute
    assignment = Task::Role.send('task.volunteer').find_by(task: task, user: user)

    assignment.destroy

    assignment
  end
end