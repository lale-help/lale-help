class Circle::ActivateMember < Mutations::Command
  
  required do
    integer :circle_id
    integer :user_id
  end

  def execute
    activate_user
    notify_user
  end

  private

  def activate_user
    user.active!
  end

  def notify_user
    UserMailer.account_activated(user).deliver_now
  end

  def circle
    Circle.find(circle_id)
  end

  def user
    circle.users.find(user_id)
  end

end