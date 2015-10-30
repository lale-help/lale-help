class Task::Update < Mutations::Command
  required do
    model :user
    model :circle
    model :working_group
    model :task, new_records: true

    string  :name
    string  :due_date
    string  :description
  end

  def validate
    add_error(:name, :too_short)        if name.length < 5
    add_error(:due_date, :empty)        unless due_date.present?
    add_error(:description, :too_short) if description.length < 5
  end

  def execute
    task.name          = name
    task.due_date      = due_date
    task.description   = description
    task.working_group = working_group
    task.save

    task
  end
end