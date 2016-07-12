class Circle::WorkingGroupsController < ApplicationController

  layout 'internal'
  before_action :ensure_logged_in
  before_action :set_back_path, only: [:show]

  include HasCircle

  def new
    authorize! :create_working_group, current_circle
    @working_group = current_circle.working_groups.build
    @form = WorkingGroup::BaseForm.new working_group: current_working_group
  end

  def create
    authorize! :create_working_group, current_circle
    @working_group = current_circle.working_groups.build
    @form = WorkingGroup::Create.new params[:working_group], working_group: current_working_group
    outcome = @form.submit

    if outcome.success?
      redirect_to working_groups_circle_admin_path(current_circle), notice: t('flash.created', name: WorkingGroup.model_name.human)
    else
      errors.add outcome.errors
      render :new
    end
  end

  def index
    authorize! :read, current_circle
  end

  def show
    authorize! :read, current_working_group

    @files              = current_working_group.files.select { |f| can?(:read, f) }

    tasks               = current_working_group.tasks.not_in_project.ordered_by_date
    @open_tasks         = tasks.not_completed.select { |f| can?(:read, f) }
    @completed_tasks    = tasks.completed.select { |f| can?(:read, f) }

    supplies            = current_working_group.supplies.not_in_project.ordered_by_date
    @open_supplies      = supplies.not_completed.select { |f| can?(:read, f) }
    @completed_supplies = supplies.completed.select { |f| can?(:read, f) }

    @projects            = current_working_group.projects
  end

  def edit
    authorize! :update, current_working_group
    @form = WorkingGroup::BaseForm.new working_group: current_working_group
  end

  def edit_members
    authorize! :update, current_working_group

    @members = current_working_group.members
    @form = WorkingGroup::AddUserForm.new(working_group: current_working_group, type: :member)
  end

  def edit_organizers
    authorize! :update, current_working_group

    @organizers = current_working_group.admins
    @form = WorkingGroup::AddUserForm.new(working_group: current_working_group, type: :organizer)
  end

  def edit_projects
    authorize! :update, current_working_group
    @projects = current_working_group.projects
  end

  def add_user
    authorize! :update, current_working_group
    @form = WorkingGroup::AddUserForm.new(params[:working_group], working_group: current_working_group)
    @form.submit

    redirect_to :back
  end

  def remove_user
    authorize! :update, current_working_group

    outcome = WorkingGroup::RemoveUser.run(params.slice(:user_id, :role_type), working_group: current_working_group)
    if outcome.success?
      redirect_to :back
    else
      redirect_to :back, alert: outcome.errors.message_list
    end
  end

  def update
    authorize! :update, current_working_group

    @form = WorkingGroup::Update.new params[:working_group], working_group: current_working_group
    outcome = @form.submit

    if outcome.success?
      redirect_to circle_working_group_path(current_circle, current_working_group), notice: t('flash.updated', name: WorkingGroup.model_name.human)
    else
      errors.add outcome.errors
      render :edit
    end
  end

  def destroy
    authorize! :destroy, current_working_group

    current_working_group.destroy

    redirect_to working_groups_circle_admin_path(current_circle), notice: t('flash.destroyed', name: WorkingGroup.model_name.human)
  end

  def join
    authorize! :join, current_working_group

    WorkingGroup::Role.member.create working_group: current_working_group, user: current_user

    redirect_to circle_working_group_path(current_circle, current_working_group)
  end

  def leave
    authorize! :leave, current_working_group
    outcome = WorkingGroup::RemoveUser.run(working_group: current_working_group, user_id: current_user.id, role_type: :all)
    redirect_to circle_working_group_path(current_circle, current_working_group), alert: outcome.errors.try(:message_list)
  end

  def disable
    authorize! :disable_working_group, current_circle
    WorkingGroup::ChangeStatus.run(working_group: current_working_group, status: :disabled)
    redirect_to working_groups_circle_admin_path(current_circle)
  end

  def activate
    authorize! :activate_working_group, current_circle
    WorkingGroup::ChangeStatus.run(working_group: current_working_group, status: :active)
    redirect_to working_groups_circle_admin_path(current_circle)
  end

  helper_method def current_working_group
    @working_group ||= WorkingGroup.find(params[:id] || params[:working_group_id])
  end

  helper_method def tab_class key
    'selected' if action_name == key
  end
end
