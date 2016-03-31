class Circle::ProjectsController < ApplicationController
  layout 'internal'
  before_action :ensure_logged_in

  include HasCircle

  def index
    # FIXME
    authorize! :read, current_circle
    @projects = Project.all
  end

  def new
    # FIXME
    authorize! :create_working_group, current_circle
    @project = current_circle.projects.build
    #@form = WorkingGroup::BaseForm.new working_group: current_working_group
  end

  def show
    # FIXME cancan, find project through circle
    authorize! :create_working_group, current_circle
    @project = current_project
  end

  def edit
    # FIXME
    authorize! :create_working_group, current_circle
    @project = current_project
  end

  def destroy
    # FIXME
    authorize! :create_working_group, current_circle

    current_project.destroy

    redirect_to circle_projects_path(current_circle), 
      notice: t('flash.destroyed', name: Project.model_name.human)
  end

  helper_method def current_project
    @project ||= current_circle.projects.find(params[:id] || params[:project_id])
  end

end

