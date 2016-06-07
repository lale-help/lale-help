class Task::Clone < Mutations::Command

  required do
    model :task
  end

  # returns an *unsaved* clone of task
  def execute
    new_task = Task.new(new_task_attributes)
    assign_location(new_task)
    new_task
  end

  private

  def new_task_attributes
    attrs = task.attributes.reject do |key, value|
      %w(id created_at updated_at completed_at).include?(key) || value.nil?
    end
    attrs[:organizers] = task.organizers
    attrs
  end

  def assign_location(new_task)
    new_location = Location.location_from(task.primary_location.address)
    #
    # Warning: Here be dragons!
    # 
    # I'm defining a method :primary_location on this *instance* of Task, overwriting
    # the method defined in the Task class. I'm doing this since there doesn't seem to be 
    # an easy way to assign the primary_location correctly on an *unsaved* task instance.
    # primary_location on this instance wouldn't be saved correctly, so I prevent saving.
    new_task.define_singleton_method(:primary_location) { new_location }
    new_task.readonly!  
  end

end
