class Circle::ActivateMember < Mutations::Command
  
  required do
    integer :circle_id
    integer :user_id
  end

  def execute
    circle.users.find(user_id).active!
  end

  private

  def circle
    Circle.find(circle_id)
  end

end