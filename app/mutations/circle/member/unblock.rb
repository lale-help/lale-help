class Circle::Member::Unblock < Circle::Member::ChangeStatus

  def execute
    change_user_status(:active)
    Circle::Member::Comments::StatusChange.run!(item: user, user: admin, circle: circle, status: :unblocked)
  end

end
