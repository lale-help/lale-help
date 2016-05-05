
class Task::Comments::ClonedTaskComment < Task::Comments::BaseComment
  required do
    model :task_cloned, class: Task
  end

  private

  def message_params
    super.tap do |params|
      params[:original_task] = task_cloned.name
    end
  end

end
