class Circle::TasksController < ApplicationController
  layout "internal"
  before_action :ensure_logged_in
  before_action :set_back_path, only: [:my, :open, :completed]

  include HasCircle

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

    if can? :create, Comment.new, current_task, current_circle
      @form = Comment::Create.new(commenter: current_user, task: current_task, comment: Comment.new)
    end
  end


  def new
    project = Project.find(params[:project_id]) if params[:project_id]
    authorize! :create_task, current_circle
    authorize!(:manage, project) if project.present?

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
      set_flash(:success)
      redirect_to circle_task_path(current_circle, outcome.result)
    else
      set_flash_now(:error)
      errors.add outcome.errors
      render :new
    end
  end


  def update
    authorize! :update, current_task

    model_params = {user: current_user, task: current_task, circle: current_circle, ability: current_ability}
    @form = Task::Update.new(params[:task], model_params, send_notifications: !!params[:send_notifications])

    outcome = @form.submit

    if outcome.success?
      set_flash(:success)
      redirect_to circle_task_path(current_circle, outcome.result)
    else
      set_flash_now(:error)
      errors.add outcome.errors
      render :edit
    end
  end


  def destroy
    authorize! :destroy, current_task
    Task::Destroy.run(task: current_task, user: current_user)
    set_flash(:success)
    redirect_to circle_working_group_path(current_task.working_group.circle, current_task.working_group)
  end


  # TODO extract to a TaskRoles controller
  def volunteer
    authorize! :volunteer, current_task

    outcome = Task::Volunteer.run(user: current_user, task: current_task)

    set_flash(outcome.success? ? :success : :error)
    redirect_to circle_task_path(current_circle, current_task)
  end


  # TODO extract to a TaskRoles controller
  def assign_volunteer
    new_volunteers = User.where(id: params['new_volunteer_ids']).to_a
    authorize!(:assign_volunteers, current_task, new_volunteers)

    outcome = Task::Assign.run(users: new_volunteers, task: current_task, current_user: current_user)

    if outcome.success? 
      set_flash(:success)
      head(:ok)
    else
      set_flash(:error)
      head(:unprocessable_entity)
    end
  end


  # TODO extract to a TaskRoles controller
  def unassign_volunteer
    user = User.find(params['user_id'])
    authorize!(:unassign_volunteers, current_task, user)

    outcome = Task::Unassign.run(users: [user], task: current_task, current_user: current_user)

    if outcome.success? 
      set_flash(:success)
      head(:ok)
    else
      set_flash(:error)
      head(:unprocessable_entity)
    end
  end


  # TODO extract to a TaskRoles controller
  def decline
    authorize! :decline, current_task

    outcome = Task::Decline.run(user: current_user, task: current_task)

    set_flash(outcome.success? ? :success : :error)
    redirect_to circle_task_path(current_circle, current_task)
  end


  def complete
    authorize! :complete, current_task

    outcome = Task::Complete.run(user: current_user, task: current_task)

    set_flash(outcome.success? ? :success : :error)
    redirect_to circle_task_path(current_circle, current_task)
  end


  def reopen
    authorize! :reopen, current_task

    outcome = Task::Reopen.run(user: current_user, task: current_task)

    set_flash(outcome.success? ? :success : :error)
    redirect_to circle_task_path(current_circle, current_task)
  end

  # TODO extract to an InvitationsController (which can then also be used by the other resources that need invitations)
  def invite
    authorize! :manage, current_task

    outcome = Task::Notifications::InvitationEmail.run(current_user: current_user, task: current_task, type: params[:type])

    if outcome.success?
      set_flash(:success, count: outcome.result.volunteers.size)
      head :ok
    else
      set_flash(:error)
      head :unprocessable_entity
    end
  end

  def clone
    authorize! :clone, current_task

    original_task_id = current_task.id
    outcome = Task::Clone.run(task: current_task)

    if outcome.success?
      set_flash(:success)
      @task = outcome.result
      @form = Task::Update.new(current_task, user: current_user, task: @task, circle: current_circle, ability: current_ability, original_task_id: original_task_id)
      render :new
    else
      set_flash(:error)
      redirect_to circle_task_path(current_circle, current_task)
    end
  end

  helper_method def current_task
    @task ||= Task.find(params[:id] || params[:task_id])
  end

  private

  def set_flash(type, options = {})
    flash[type] = flash_msg_for(type, options)
  end

  def set_flash_now(type, options = {})
    flash.now[type] = flash_msg_for(type, options)
  end

  def flash_msg_for(type, options)
    msg_options = { scope: "tasks.flash.#{action_name}" }.merge(options)
    t(type, msg_options)
  end
end
