class Task::Complete < Mutations::Command
  required do
    model :user
    model :task
  end

  def execute
    task.complete = true

    if task.save
      Comment::AutoComment.run(item: task, message: 'completed', user: user)
    else
      add_error :task, :completion_failed
    end

    task
  end
end
