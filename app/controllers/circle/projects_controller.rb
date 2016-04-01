class Circle::ProjectsController < ApplicationController
  layout 'internal'
  before_action :ensure_logged_in

  include HasCircle

  def index
    # FIXME
    authorize! :read, current_circle
    @projects = current_circle.projects
  end

  def new
    # FIXME
    authorize! :create_working_group, current_circle
    
    # FIXME must be built of one of the current_user's working groups (group admin)
    # FIXME remove @project if possible
    @project = current_circle.projects.build
    @form = Project::Create.new(user: current_user, project: @project, circle: current_circle, ability: current_ability)
  end

  def show
    # FIXME cancan, find project through circle
    authorize! :create_working_group, current_circle
    @project = current_project
  end

  def edit
    # FIXME
    authorize! :create_working_group, current_circle
    # FIXME remove @project if possible
    @project = current_project
    @form = Project::Update.new(user: current_user, project: @project, circle: current_circle, ability: current_ability)
  end

  def create
    @project = Project.new
    @form = Project::Create.new(params[:project], user: current_user, project: @project, circle: current_circle, ability: current_ability)
    # FIXME
    authorize! :create_working_group, current_circle
    #authorize! :create_task, @form.working_group

    outcome = @form.submit

    if outcome.success?
      redirect_to circle_project_path(current_circle, outcome.result), notice: t('flash.created', name: Project.model_name.human)
    else
      errors.add outcome.errors
      render :new
    end
  end

  def update
    # FIXME
    authorize! :create_working_group, current_circle
    @form = Project::Update.new(params[:project], user: current_user, project: current_project, circle: current_circle, ability: current_ability)
    outcome = @form.submit
    if outcome.success?
      redirect_to circle_task_path(current_circle, outcome.result), notice: t('flash.updated', name: Task.model_name.human)
    else
      errors.add outcome.errors
      render :edit
    end
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

