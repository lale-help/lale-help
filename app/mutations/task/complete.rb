class Task::Complete < Mutations::Command
  required do
    model :user
    model :task
  end

  def execute
    task.complete = true

    add_error :task, :completion_failed unless task.save

    task
  end
end