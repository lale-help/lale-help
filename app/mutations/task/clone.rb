class Task::Clone < Mutations::Command
  required do
    model :user
    model :task
  end

  # TODO validate & handle error
  def execute
    cloned_task = Task.new(new_task_attributes)
    cloned_task
  end

  private

  # TODO: what about task roles?
  def new_task_attributes
    task.attributes.reject do |key, value|
      %w(id created_at updated_at completed_at).include?(key) || value.nil?
    end
  end

end
