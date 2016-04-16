class Circle::TasksController < ApplicationController
  layout "internal"
  before_action :ensure_logged_in
  before_action :set_back_path, only: [:index, :my, :open, :completed]

  include HasCircle

  def index
    authorize! :read, current_circle
    @tasks = current_circle.tasks.not_completed.ordered_by_date.select do |task|
      can? :read, task
    end
  end


  def completed
    authorize! :read, current_circle
    @tasks = current_circle.tasks.completed.ordered_by_date.select do |task|
      can? :read, task
    end
  end

  def my
    authorize! :read, current_circle

    tasks_vol = current_user.tasks.for_circle(current_circle).with_role('task.volunteer').ordered_by_date
    tasks_org = current_user.tasks.for_circle(current_circle).with_role('task.organizer').ordered_by_date
    @tasks = OpenStruct.new(
        open: tasks_vol.not_completed,
        closed: tasks_vol.completed,
        open_org: tasks_org.not_completed
    )
  end


  def open
    authorize! :read, current_circle
    @tasks = current_circle.tasks.unassigned.not_completed.ordered_by_date
  end


  def show
    authorize! :read, current_task

    if can? :create, Comment, current_task
      @form = Comment::Create.new(commenter: current_user, task: current_task, comment: Comment.new)
    end
  end


  def new
    authorize! :create_task, current_circle
    @form = Task::Create.new(user: current_user, circle: current_circle, ability: current_ability, project_id: params[:project_id])
  end


  def edit
    authorize! :update, current_task
    @form = Task::Update.new(current_task, user: current_user, task: current_task, circle: current_circle, ability: current_ability)
  end


  def create
    authorize! :create_task, current_circle
    @form = Task::Create.new(params[:task], user: current_user, circle: current_circle, ability: current_ability)

    outcome = @form.submit

    if outcome.success?
      redirect_to circle_task_path(current_circle, outcome.result), notice: t('flash.created', name: Task.model_name.human)

    else
      errors.add outcome.errors

      render :new
    end
  end


  def update
    authorize! :update,      current_task

    @form = Task::Update.new(params[:task], user: current_user, task: current_task, circle: current_circle, ability: current_ability)

    outcome = @form.submit

    if outcome.success?
      redirect_to circle_task_path(current_circle, outcome.result), notice: t('flash.updated', name: Task.model_name.human)

    else
      errors.add outcome.errors
      render :edit
    end
  end


  def destroy
    authorize! :destroy, current_task

    Task::Destroy.run(task: current_task, user: current_user)

    redirect_to circle_tasks_path(current_circle), notice: t('flash.destroyed', name: Task.model_name.human)
  end


  def volunteer
    authorize! :volunteer, current_task

    outcome = Task::Volunteer.run(user: current_user, task: current_task)

    if outcome.success?
      redirect_to circle_task_path(current_circle, current_task), notice: t('tasks.flash.volunteered', name: current_task.name)
    else
      redirect_to circle_task_path(current_circle, current_task), alert: t('tasks.flash.volunteer_failed', name: current_task.name)
    end
  end

  def decline
    authorize! :decline, current_task

    outcome = Task::Decline.run(user: current_user, task: current_task)

    if outcome.success?
      redirect_to circle_task_path(current_circle, current_task), notice: t('tasks.flash.volunteered', name: current_task.name)
    else
      redirect_to circle_task_path(current_circle, current_task), alert: t('tasks.flash.volunteer_failed', name: current_task.name)
    end
  end


  def complete
    authorize! :complete, current_task

    outcome = Task::Complete.run(user: current_user, task: current_task)

    if outcome.success?
      redirect_to circle_task_path(current_circle, current_task), notice: t('tasks.flash.completed', name: current_task.name)
    else
      redirect_to circle_task_path(current_circle, current_task), alert: t('tasks.flash.complete_failed', name: current_task.name)
    end
  end


  def reopen
    authorize! :reopen, current_task

    outcome = Task::Reopen.run(user: current_user, task: current_task)

    if outcome.success?
      redirect_to circle_task_path(current_circle, current_task), notice: t('tasks.flash.reopened', name: current_task.name)
    else
      redirect_to circle_task_path(current_circle, current_task), alert: t('tasks.flash.reopening_failed', name: current_task.name)
    end
  end

  # TODO extract to an InvitationsController (which can then also be used by the other resources that need invitations)
  def invite
    authorize! :manage, current_task

    outcome = Task::Notifications::InvitationEmail.run(current_user: current_user, task: current_task, type: params[:type])

    if outcome.success?
      flash[:notice] = t('flash.actions.invited', name: current_task.name, count: outcome.result.volunteers.size, model: Task.model_name.human.downcase )
      redirect_to circle_task_path(current_circle, current_task)
    else
      flash[:error] = t('tasks.flash.invite_failed', name: current_task.name)
      redirect_to circle_task_path(current_circle, current_task)
    end
  end

  def clone
    authorize! :clone, current_task

    outcome = Task::Clone.run(user: current_user, task: current_task)

    if outcome.success?
      @task = outcome.result
      @form = Task::Update.new(current_task, user: current_user, task: @task, circle: current_circle, ability: current_ability)
      render :new

    else
      redirect_to circle_task_path(current_circle, current_task), alert: t('tasks.flash.cloning_failed', name: current_task.name)
    end
  end

  helper_method def current_task
    @task ||= Task.find(params[:id] || params[:task_id])
  end

  helper_method def page
    t = current_task
    @page ||= begin
      OpenStruct.new(
        is_missing_volunteers: t.is_missing_volunteers?,
        missing_volunteer_count: t.missing_volunteer_count,
        adjusted_missing_volunteer_count: can?(:volunteer, t) ? t.missing_volunteer_count - 1 : t.missing_volunteer_count
      )
    end
  end
end
