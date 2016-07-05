class Circle::Member::Comments::StatusChange < Comment::AutoComment

  required do
    model :circle
    string :status
  end

  def circle_language
    circle.language
  end

  def message
    "status_change_#{status}"
  end

  def message_params
    {
        member: item.name
    }
  end
end
