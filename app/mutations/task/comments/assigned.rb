class Task::Comments::Assigned < Comment::AutoComment

  required do
    array :assignees
    string :message, default: nil
  end

  def message
    :users_assigned
  end

  def message_params
    {
      count: assignees.size,
      assignees: assignees.map(&:name).sort.to_sentence,
      assigner: user.name
    }
  end
end
