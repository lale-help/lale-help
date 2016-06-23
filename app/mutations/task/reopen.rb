class Task::Reopen < Mutations::Command
  required do
    model :user
    model :task
  end

  def execute
    task.completed_at = nil

    if task.save
      Comment::AutoComment.run(item: task, message: 'reopened', user: user)
    else
      add_error :task, :reopening_failed
    end

    task
  end
end
