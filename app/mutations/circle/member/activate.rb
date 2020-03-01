class Circle::Member::Activate < Circle::Member::ChangeStatus

  def execute
    change_user_status(:active)
    Circle::Member::Comments::StatusChange.run!(item: user, user: admin, circle: circle, status: :activated)
    notify_user
  end

  private

  def notify_user
    UserMailer.account_activated(circle.id, user.id).deliver_later
  end

end
