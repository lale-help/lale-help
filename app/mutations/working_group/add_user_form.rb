class WorkingGroup::AddUserForm < ::Form
  attribute :working_group, :model, primary: true
  attribute :type, :symbol, in: %i(member organizer)
  attribute :user_id, :integer
  attribute :user, :model, class: User, default: proc{ User.find_by(id: user_id) }

  def available_users
    current_members = type == :member ? working_group.users : working_group.admins
    working_group.circle.users.active.where.not(users: { id:  current_members })
  end

  class Submit < ::Form::Submit
    def execute
      if type == :organizer
        working_group.roles.admin.find_or_create_by! user: user
      end

      working_group.roles.member.find_or_create_by! user: user
    end
  end
end