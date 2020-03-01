class Circle::Member::ChangeStatus < Mutations::Command

  required do
    integer :circle_id
    integer :id
    model :admin, class: User
  end

  private

  def change_user_status(status)
    # an admin has multiple roles in one circle.
    circle.roles.where(user: user).each { |role| role.update_attribute(:status, status) }
  end

  def circle
    Circle.find(circle_id)
  end

  def user
    circle.users.find(id)
  end

end
