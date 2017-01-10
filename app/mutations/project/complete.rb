class Project::Complete < Mutations::Command

  required do
    model :project
    model :current_user, class: User
  end

  def execute
    project.complete!
    close_all_tasks_supplies
  end

  def close_all_tasks_supplies
    project.tasks.incomplete.each { |t| Task::Complete.run(user: current_user, task: t) }
    project.supplies.incomplete.each { |s| Supply::Complete.run(user: current_user, supply: s) }
  end
end
