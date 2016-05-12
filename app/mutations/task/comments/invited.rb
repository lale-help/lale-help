class Task::Comments::Invited < Task::Comments::Base
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
