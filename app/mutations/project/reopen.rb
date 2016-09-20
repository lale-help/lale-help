class Project::Reopen < Mutations::Command

  required do
    model :project
  end

  def execute
    project.open!
  end
end
