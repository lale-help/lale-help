class Circle::MembersController < ApplicationController

  skip_authorization_check # TODO: REMOVE

  include HasCircle
  include HasWorkingGroupFilters

  def index
    members = current_circle.users.select('users.*, count(distinct circle_roles.*) as circle_role_count').group('users.id').order('circle_role_count DESC')
    members = members.joins(:working_group_roles).where(working_group_roles: { working_group: current_working_group }) if current_working_group.present?

    @members = members.distinct.includes(:identity, :working_groups, :circle_roles)
  end
end