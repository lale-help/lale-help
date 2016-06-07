class WorkingGroup::RemoveUser  < Mutations::Command

  required do
    model :working_group
    integer :user_id
  end

  def validate
    add_error(:organizer_id, :at_least_one_required) if user_is_last_organizer? 
  end

  def execute
    # a user may have an organizer and volunteer role, delete all of them.
    working_group.roles.where(user_id: user_id).delete_all
  end

  private

  def user_is_last_organizer?
    admin_roles = working_group.roles.admin
    admin_roles.count == 1 && admin_roles.first.user_id == user_id
  end
end
