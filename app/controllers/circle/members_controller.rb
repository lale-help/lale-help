class Circle::MembersController < ApplicationController

  skip_authorization_check # TODO: REMOVE

  include HasCircle

  def index
    members = current_circle.users.select('users.*, count(distinct circle_roles.*) as circle_role_count').group('users.id').order('circle_role_count DESC')
    @members = members.distinct.includes(:identity, :working_groups, :circle_roles)
  end

  def show
    authorize! :read, current_member, current_circle
  end

  helper_method def current_member
    @current_member ||= current_circle.users.find(params[:id])
  end

end
