class Circle::MembersController < ApplicationController

  skip_authorization_check # TODO: REMOVE
  before_action :ensure_logged_in
  include HasCircle

  def index
    authorize! :manage, current_circle
    @members = current_circle.users.order('last_name asc').includes(:identity, :working_groups, :circle_roles)
    @total_members = @members.length
  end

  def show
    authorize! :read, current_member, current_circle
  end

  helper_method def current_member
    @current_member ||= current_circle.users.find(params[:id])
  end

end
