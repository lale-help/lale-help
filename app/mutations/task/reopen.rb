class Task::Reopen < Mutations::Command
  required do
    model :user
    model :task
  end

  def execute
    task.completed_at = nil

    add_error :task, :reopening_failed unless task.save

    task
  end
end
