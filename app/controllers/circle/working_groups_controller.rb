class Circle::WorkingGroupsController < ApplicationController
  layout 'internal'

  include HasCircle

  before_action :ensure_logged_in
  load_and_authorize_resource :circle
  load_and_authorize_resource through: :circle

  def new
  end

  def edit
  end

  def create
    respond_to do |format|
      if @working_group.save
        format.html { redirect_to [@circle], notice: t('flash.created', name: WorkingGroup.model_name.human) }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @working_group.update(working_group_params)
        format.html { redirect_to [@circle], notice: t('flash.updated', name: WorkingGroup.model_name.human) }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @working_group.destroy
    respond_to do |format|
      format.html { redirect_to @circle, notice: t('flash.destroyed', name: WorkingGroup.model_name.human) }
      format.json { head :no_content }
    end
  end

  private
      # Never trust parameters from the scary internet, only allow the white list through.
    def working_group_params
      params[:working_group].permit(:name)
    end
end
