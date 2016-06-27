class Circle::Member::Block < Circle::Member::ChangeStatus
  
  def execute
    change_user_status(:blocked)
  end

end