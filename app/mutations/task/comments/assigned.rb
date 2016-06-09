class Task::Comments::Assigned < Task::Comments::Base

  def message
    :user_assigned
  end

end
