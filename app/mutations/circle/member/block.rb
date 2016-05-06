class Circle::Member::Block < Mutations::Command
  
  required do
    integer :circle_id
    integer :id
  end

  def execute
    block_user
  end

  private

  def block_user
    circle.roles.find_by(user: user).blocked!
  end

  def circle
    Circle.find(circle_id)
  end

  def user
    circle.users.find(id)
  end

end