class Task::Comments::Volunteered < Comment::AutoComment

  def message
    :user_volunteered
  end

end
