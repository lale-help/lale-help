class Circle::MembersController < ApplicationController

  skip_authorization_check # TODO: REMOVE
  before_action :ensure_logged_in
  include HasCircle

  def index
    members = current_circle.users.select('users.*, count(distinct circle_roles.*) as circle_role_count').group('users.id').order('users.last_name asc, circle_role_count DESC')
    @members = members.distinct.where('users.public_profile = true').includes(:identity, :working_groups, :circle_roles)
    @total_members = members.distinct.length
  end

  def show
    authorize! :read, current_member, current_circle
  end

  helper_method def current_member
    @current_member ||= current_circle.users.find(params[:id])
  end

end
