class Task::Comments::Invited < Comment::AutoComment
  required do
    integer :invite_count
  end

  private

  def message_params
    { invite_count: invite_count }
  end

  def message
    :invited
  end
end
