class Circle::WorkingGroupsController < ApplicationController
  layout 'internal'

  include HasCircle

  def index
    authorize! :read, current_circle
  end

  def new
    authorize! :create_working_group, current_circle
    @working_group = current_circle.working_groups.build
    @form = WorkingGroup::BaseForm.new working_group: current_working_group
  end

  def show
    authorize! :read, current_working_group
  end


  def edit
    authorize! :update, current_working_group
    @form = WorkingGroup::BaseForm.new working_group: current_working_group
  end

  def create
    authorize! :create_working_group, current_circle
    @working_group = current_circle.working_groups.build
    @form = WorkingGroup::BaseForm.new params[:working_group], working_group: current_working_group
    outcome = @form.submit

    if outcome.success?
      redirect_to circle_admin_path(current_circle), notice: t('flash.created', name: WorkingGroup.model_name.human)
    else
      render :new
    end

  end

  def update
    authorize! :update, current_working_group

    @form = WorkingGroup::BaseForm.new params[:working_group], working_group: current_working_group
    outcome = @form.submit

    if outcome.success?
      redirect_to circle_working_group_path(current_circle, current_working_group), notice: t('flash.updated', name: WorkingGroup.model_name.human)
    else
      render :edit
    end
  end

  def destroy
    authorize! :destroy, current_working_group

    current_working_group.destroy

    redirect_to circle_admin_path(current_circle), notice: t('flash.destroyed', name: WorkingGroup.model_name.human)
  end

  def join
    authorize! :join, current_working_group

    WorkingGroup::Role.member.create working_group: current_working_group, user: current_user

    redirect_to circle_working_group_path(current_circle, current_working_group)
  end

  def leave
    authorize! :leave, current_working_group

    WorkingGroup::Role.where(working_group: current_working_group, user: current_user).delete_all

    redirect_to circle_working_group_path(current_circle, current_working_group)
  end



  helper_method def current_working_group
    @working_group ||= WorkingGroup.find(params[:id] || params[:working_group_id])
  end
end
