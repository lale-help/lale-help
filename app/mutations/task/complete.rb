class Task::Complete < Mutations::Command
  required do
    model :user
    model :task
  end

  def execute
    task.complete = true

    if task.save
      Task::Comments::BaseComment.run(task: task, message: 'completed', user: user)
    else
      add_error :task, :completion_failed
    end

    task
  end
end
