class Circle::MembersController < ApplicationController

  skip_authorization_check # TODO: REMOVE
  before_action :ensure_logged_in
  before_action :set_back_path, only: [:index, :public]

  include HasCircle

  def index
    authorize! :manage, current_circle
    @members       = active_users
    @organizers    = organizers
    @total_members = @members.count
  end


  def public
    @members       = active_users.where(public_profile: true)
    @total_members = @members.count
  end


  def show
    authorize! :read, current_member, current_circle
    if can? :create, Comment.new, current_member, current_circle
      @form = Comment::Create.new(commenter: current_user, item: current_member, comment: Comment.new)
    end
  end


  def activate
    outcome = Circle::Member::Activate.run(params.merge(admin: current_user))
    if request.xhr?
      head (outcome ? :ok : :unprocessable_entity)
    else
      redirect_to circle_member_path(current_circle, current_member)
    end
  end


  def block
    authorize! :block, current_member, current_circle
    Circle::Member::Block.run(params.merge(admin: current_user))
    redirect_to circle_member_path(current_circle, current_member)
  end


  def unblock
    authorize! :unblock, current_member, current_circle
    Circle::Member::Unblock.run(params.merge(admin: current_user))
    redirect_to circle_member_path(current_circle, current_member)
  end


  helper_method def current_member
    @current_member ||= current_circle.users.find(params[:id])
  end

  private

  def active_users
    current_circle.users.active
      .includes(:identity, :working_groups, :circle_roles)
      .order('last_name asc')
  end

  def organizers
    circle_organizers = User.
        select('users.id, count(*) as role_count').
        joins(:circle_roles).
        where(circle_roles: { role_type: Circle::Role::ORGANIZER_TYPE_IDS, circle: current_circle }).
        group('users.id')

    working_group_organizers = User.
        select('users.id, count(*) as role_count').
        joins(:working_group_roles).
        where(working_group_roles: { role_type: WorkingGroup::Role::ORGANIZER_TYPE_IDS, working_group_id: current_circle.working_groups }).
        group('users.id')

    counts = (circle_organizers + working_group_organizers).each_with_object(Hash.new) do |user, obj|
      obj[user.id] ||= 0
      obj[user.id] += user.role_count
    end

    all_organizers = User.where(id: counts.keys).includes(:identity, :working_groups, :circle_roles)

    all_organizers.sort_by{|u| -counts[u.id] }
  end

end
