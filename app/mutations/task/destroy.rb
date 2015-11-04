class Task::Destroy < Mutations::Command
  required do
    model :user
    model :task
  end

  def execute
    task.destroy
  end
end