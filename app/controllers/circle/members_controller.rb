#
# a "Member" is a user in a circle. Technically this is implemented
# with roles; a user is member in a circle if (s)he has a circle_role.
#
class Circle::MembersController < ApplicationController

  before_action :ensure_logged_in
  before_action :set_back_path, only: :index

  include HasCircle

  def index
    authorize! :read, current_circle
    @members    = active_users.select { |member| can?(:read, member, current_circle) }
    @organizers = organizers.select { |member| can?(:read, member, current_circle) }
    @totals     = { members: active_users.count, organizers: organizers.count }
    respond_to do |format|
      format.html
      format.pdf do
        render  pdf: "#{current_circle.name}_" + t("pdf.list") + "_" + Date.today.to_formatted_s(:number),
                template: 'circle/members/pdf.slim',
                layout: 'pdf.slim',
                locals: { members: @members },
                orientation: 'Landscape'
      end
    end
  end

  def show
    authorize! :read, current_member, current_circle
    if can? :create, Comment.new, current_member, current_circle
      @form = Comment::Create.new(commenter: current_user, item: current_member, comment: Comment.new)
    end
  end

  def edit
    authorize! :edit, current_member, current_circle
    @form = User::Update.new(user: current_member, current_circle: current_circle)
  end

  def update
    authorize! :edit, current_member, current_circle
    @form = User::Update.new(params[:user], user: current_member, current_circle: current_circle)
    outcome = @form.submit
    errors.add outcome.errors
    if outcome.success?
      flash[:notice] = t("flash.user.account.saved")
      redirect_to circle_member_url(current_circle, current_member)
    else
      flash[:error] = t("flash.user.account.save-failed")
      render :edit
    end
  end

  def activate
    authorize! :activate_member, current_circle
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
    @_active_users ||= current_circle.users.active
      .includes(:identity, :working_groups, :circle_roles)
      .order('last_name asc')
  end

  def organizers
    @_organizers ||= begin
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

      all_organizers.sort_by { |u| -counts[u.id] }
    end
  end

end
