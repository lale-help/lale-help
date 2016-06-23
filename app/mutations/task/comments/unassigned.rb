class Task::Comments::Unassigned < Comment::AutoComment

  required do
    array :unassignees
    string :message, default: nil
  end

  def message
    :users_unassigned
  end

  def message_params 
    { 
      count: unassignees.size,
      unassignees: unassignees.map(&:name).sort.to_sentence,
      unassigner: user.name
    }
  end
end
