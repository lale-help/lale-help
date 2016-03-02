class Circle::PublicMembersController < ApplicationController

  skip_authorization_check # TODO: REMOVE

  include HasCircle

  before_action :ensure_logged_in

  def index
    members = current_circle.users.select('users.*, count(distinct circle_roles.*) as circle_role_count').group('users.id').order('users.last_name asc, circle_role_count DESC')
    @members = members.where('users.public_profile = true').distinct.includes(:identity, :working_groups, :circle_roles)
    @total_members = members.distinct.length
  end

end
