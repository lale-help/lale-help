class Project::Destroy < Mutations::Command
  required do
    model :project
  end

  def execute
    project.transaction do
      project.tasks.destroy_all
      project.supplies.destroy_all
      project.destroy
    end
  end
end