class Circle::TasksController < ApplicationController
  layout "internal"
  before_action :ensure_logged_in
  load_and_authorize_resource :circle
  load_and_authorize_resource through: :circle, except: [:volunteer, :new, :complete]
  load_and_authorize_resource id_param: :task_id, only: [:complete, :volunteer]

  include HasCircle
  include HasWorkingGroupFilters

  # GET /tasks
  # GET /tasks.json
  def index
    tasks = current_circle.tasks.order('due_date asc')
    tasks = tasks.where(working_group: current_working_group) if current_working_group.present?

    open_tasks   = tasks.not_completed
    closed_tasks = tasks.completed

    @tasks = OpenStruct.new(open: open_tasks.limit(10), closed: closed_tasks.limit(10))
  end

  # GET /tasks/new
  def new
    @task = @circle.working_groups.first.tasks.build
    authorize! :new, @task
  end

  # GET /tasks/1/edit
  def edit
  end


  # POST /tasks
  # POST /tasks.json
  def create
    respond_to do |format|
      if @task.save
        format.html { redirect_to @circle, notice: t('flash.created', name: Task.model_name.human) }
      else
        @working_group_names_and_ids = @circle.working_groups.map{|wg| [wg.name, wg.id]}
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /tasks/1
  # PATCH/PUT /tasks/1.json
  def update
    respond_to do |format|
      if @task.update(task_params)
        format.html { redirect_to circle_tasks_path(@circle), notice: t('flash.updated', name: Task.model_name.human) }
      else
        format.html { render :edit }
      end
    end
  end

  # DELETE /tasks/1
  # DELETE /tasks/1.json
  def destroy
    @task.destroy
    respond_to do |format|
      format.html { redirect_to [@circle], notice: t('flash.destroyed', name: Task.model_name.human) }
      format.json { head :no_content }
    end
  end

  def volunteer
    @task.volunteers << current_user
    if @task.save
      redirect_to [@circle], notice: t('tasks.flash.volunteered', name: @task.name)
    else
      redirect_to [@circle], alert: t('tasks.flash.volunteer_failed', name: @task.name)
    end
  end

  def complete
    @task.complete = true
    if @task.save
      redirect_to [@circle], notice: t('tasks.flash.completed', name: @task.name)
    else
      redirect_to [@circle], alert: t('tasks.flash.complete_failed', name: @task.name)
    end
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def task_params
      params[:task].permit(:name, :description, :working_group_id, :due_date)
    end
end
