class WorkingGroup::RemoveUser  < Mutations::Command

  required do
    model :working_group
    string :role_type
    integer :user_id
  end


  def validate
    if user_is_last_admin?
      add_error(:organizer_id, :at_least_one_required) 
    end
    unless %i(member admin).include?(role_type.to_sym)
      add_error(:role_type, :at_least_one_required) 
    end
  end

  def execute
    if (role_type.to_sym == :admin)
      # only delete admin role, keep the member role
      role_id = WorkingGroup::Role.role_types[:admin]
      user_roles.find_by(role_type: role_id).destroy
    else
      # can't be admin without being member, delete all roles
      user_roles.destroy_all
    end
  end

  private

  def user_roles
    User.find(user_id).working_group_roles
  end

  def find_role
    user    = User.find(user_id)
    role_id = WorkingGroup::Role.role_types[role_type]
    user.working_group_roles.find_by(role_type: role_id)
  end

  def user_is_last_admin?
    admin_roles = working_group.roles.admin
    admin_roles.count == 1 && admin_roles.first.user_id == user_id
  end
end
