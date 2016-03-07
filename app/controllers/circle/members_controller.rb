class Circle::MembersController < ApplicationController

  skip_authorization_check # TODO: REMOVE
  before_action :ensure_logged_in

  include HasCircle

  def index
    authorize! :manage, current_circle
    @members       = active_members
    @total_members = @members.count
  end


  def public
    @members       = active_members.where(public_profile: true)
    @total_members = @members.count
  end


  def show
    authorize! :read, current_member, current_circle
  end

  helper_method def current_member
    @current_member ||= current_circle.users.active.find(params[:id])
  end

  private 

  def active_members
    current_circle.users.active
      .includes(:identity, :working_groups, :circle_roles)
      .order('last_name asc')
  end

end
