class Project::Destroy < Mutations::Command
  required do
    model :project
  end

  def execute
    ActiveRecord::Base.logger.level = Logger::DEBUG
    project.transaction do
      project.tasks.destroy_all
      project.supplies.destroy_all
      project.destroy
    end
  end
end