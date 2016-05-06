class Circle::Member::ChangeStatus < Mutations::Command
  
  required do
    integer :circle_id
    integer :id
  end

  private

  def change_user_status(status)
    circle.roles.find_by(user: user).update_attribute(:status, status)
  end

  def circle
    Circle.find(circle_id)
  end

  def user
    circle.users.find(id)
  end

end
