class Task::Create < Mutations::Command
  required do
    model :user
    model :circle
    model :working_group

    string  :name
    string  :due_date
    string  :description
  end


  def execute
    task = working_group.tasks.build

    outcome = Task::Update.run({task: task}, inputs)

    Task::Role.send('task.organizer').create user: user, task: task

    merge_errors(outcome.errors) if outcome.errors.present?

    outcome.result
  end
end