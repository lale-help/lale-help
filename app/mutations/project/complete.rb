class Project::Complete < Mutations::Command

  required do
    model :project
  end

  def execute
    project.complete!
  end
end
