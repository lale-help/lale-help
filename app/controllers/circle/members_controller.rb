class Circle::MembersController < ApplicationController

  skip_authorization_check # TODO: REMOVE

  include HasCircle

  def index
    if current_user.admin?
      members = current_circle.users.select('users.*, count(distinct circle_roles.*) as circle_role_count').group('users.id').order('circle_role_count DESC')
    else
      members = current_circle.users.select('users.*, count(distinct circle_roles.*) as circle_role_count').where("public_profile = 'true'").group('users.id').order('circle_role_count DESC')
    end
    @members = members.distinct.includes(:identity, :working_groups, :circle_roles)
  end
end