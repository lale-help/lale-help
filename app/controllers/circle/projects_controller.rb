class Circle::ProjectsController < ApplicationController
  layout 'internal'
  before_action :ensure_logged_in

  include HasCircle

  def index
    # FIXME
    authorize! :read, current_circle
    @projects = current_circle.projects
  end

  def show
    # FIXME cancan
    authorize! :create_working_group, current_circle
  end

  def new
    # FIXME
    authorize! :create_working_group, current_circle
    
    @form = Project::Create.new(user: current_user, circle: current_circle, ability: current_ability)
  end

  def create
    @form = Project::Create.new(params[:project], user: current_user, circle: current_circle, ability: current_ability)
    # FIXME
    authorize! :create_working_group, current_circle

    outcome = @form.submit

    if outcome.success?
      redirect_to circle_projects_path(current_circle), notice: t('flash.created', name: Project.model_name.human)
    else
      errors.add outcome.errors
      render :new
    end
  end

  def edit
    # FIXME
    authorize! :create_working_group, current_circle
    @form = Project::Update.new(user: current_user, project: current_project, circle: current_circle, ability: current_ability)
  end

  def update
    # FIXME
    authorize! :create_working_group, current_circle
    @form = Project::Update.new(params[:project], user: current_user, project: current_project, circle: current_circle, ability: current_ability)
    outcome = @form.submit
    if outcome.success?
      redirect_to circle_projects_path(current_circle), notice: t('flash.updated', name: Project.model_name.human)
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

