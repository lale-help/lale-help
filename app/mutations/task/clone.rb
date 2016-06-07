class Task::Clone < Mutations::Command
  required do
    model :user
    model :task
  end

  # TODO validate & handle error
  def execute
    Task.new(new_task_attributes)
  end

  private

  def new_task_attributes
    attrs = task.attributes.reject do |key, value|
      %w(id created_at updated_at completed_at).include?(key) || value.nil?
    end
    attrs[:organizers] = task.organizers
    # FIXME primary task location must still be cloned
    attrs
  end

end
