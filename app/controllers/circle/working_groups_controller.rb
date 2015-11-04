class Circle::WorkingGroupsController < ApplicationController
  layout 'internal'

  include HasCircle

  def index
    authorize! :read, current_circle
  end

  def new
    authorize! :create_working_group, current_circle
    @working_group = current_circle.working_groups.build
  end

  def show
    authorize! :read, current_working_group
  end


  def edit
    authorize! :update, current_working_group
  end

  def create
    authorize! :create_working_group, current_circle
    @working_group = current_circle.working_groups.build working_group_params

    if current_working_group.save
      redirect_to circle_admin_path(current_circle), notice: t('flash.created', name: WorkingGroup.model_name.human)
    else
      render :new
    end

  end

  def update
    authorize! :update, current_working_group

    if current_working_group.update(working_group_params)
      redirect_to circle_admin_path(current_circle), notice: t('flash.updated', name: WorkingGroup.model_name.human)
    else
      render :edit
    end
  end

  def destroy
    authorize! :destroy, current_working_group

    current_working_group.destroy

    redirect_to circle_admin_path(current_circle), notice: t('flash.destroyed', name: WorkingGroup.model_name.human)
  end


  helper_method def current_working_group
    @working_group ||= WorkingGroup.find(params[:id])
  end

  private

  def working_group_params
    params[:working_group].permit(:name)
  end
end
