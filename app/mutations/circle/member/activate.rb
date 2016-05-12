class Circle::Member::Activate < Circle::Member::ChangeStatus
  
  def execute
    change_user_status(:active)
    notify_user
  end

  private

  def notify_user
    UserMailer.account_activated(circle, user).deliver_now
  end

end