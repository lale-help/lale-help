class Circle::ProjectsController < ApplicationController
  layout 'internal'
  before_action :ensure_logged_in
  before_action :set_back_path, only: [:show]

  include HasCircle

  def index
    authorize! :read, current_circle
    @projects = current_circle.projects.order(:name).select { |project| can?(:read, project) }
  end

  def show
    authorize! :read, current_project
  end

  def new
    authorize! :create_project, current_circle
    @form = Project::Create.new(user: current_user, circle: current_circle, ability: current_ability)
  end

  def create
    authorize! :create_project, current_circle
    @form = Project::Create.new(params[:project], user: current_user, circle: current_circle, ability: current_ability)

    outcome = @form.submit

    if outcome.success?
      redirect_to circle_project_path(current_circle, @form.project), notice: t('flash.created', name: Project.model_name.human)
    else
      errors.add outcome.errors
      render :new
    end
  end

  def edit
    authorize! :update, current_project
    @form = Project::Update.new(user: current_user, project: current_project, circle: current_circle, ability: current_ability)
  end

  def update
    authorize! :update, current_project
    @form = Project::Update.new(params[:project], user: current_user, project: current_project, circle: current_circle, ability: current_ability)
    outcome = @form.submit
    if outcome.success?
      redirect_to circle_project_path(current_circle, current_project), notice: t('flash.updated', name: Project.model_name.human)
    else
      errors.add outcome.errors
      render :edit
    end
  end

  def destroy
    authorize! :destroy, current_project
    Project::Destroy.run(project: current_project)

    redirect_to circle_projects_path(current_circle),
      notice: t('flash.destroyed', name: Project.model_name.human)
  end

  # TODO extract to an InvitationsController (which can then also be used by the other resources that need invitations)
  def invite
    authorize! :manage, current_project

    outcome = Project::Notifications::InvitationEmail.run(current_user: current_user, project: current_project, type: params[:type])

    if outcome.success?
      flash[:notice] = t('flash.actions.invited',
        name: current_project.name, count: outcome.result.volunteers.size, model: Project.model_name.human.downcase)
    else
      # FIXME adapt message
      flash[:error] = t('tasks.flash.invite_failed', name: current_project.name)
    end
    redirect_to circle_project_path(current_circle, current_project)
  end

  helper_method def current_project
    @project ||= current_circle.projects.find(params[:id] || params[:project_id])
  end

end
