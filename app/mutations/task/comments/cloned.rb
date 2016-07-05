class Task::Comments::Cloned < Comment::AutoComment
  required do
    model :task_cloned, class: Task
  end

  private

  def message_params
    { original_task: task_cloned.name }
  end

  def message
    :copied
  end

end
