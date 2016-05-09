class Circle::MembersController < ApplicationController

  skip_authorization_check # TODO: REMOVE
  before_action :ensure_logged_in
  before_action :set_back_path, only: [:index, :public]

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
    if can? :create, Comment, current_member
      @form = Comment::Create.new(commenter: current_user, item: current_member, comment: Comment.new)
    end
  end

  helper_method def current_member
    @current_member ||= current_circle.users.find(params[:id])
  end

  private

  def active_members
    current_circle.users.active
      .includes(:identity, :working_groups, :circle_roles)
      .order('last_name asc')
  end

end
