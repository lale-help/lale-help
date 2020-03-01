class Circle::Member::Block < Circle::Member::ChangeStatus

  def execute
    change_user_status(:blocked)
    Circle::Member::Comments::StatusChange.run!(item: user, user: admin, circle: circle, status: :blocked)
  end

end
