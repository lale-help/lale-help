class TasksController < ApplicationController
  layout "circle_page"
  before_action :ensure_logged_in
  before_action :set_task, only: [:edit, :update, :destroy]
  before_action :set_circle

  # GET /tasks
  # GET /tasks.json
  def index
    @tasks = Task.all
  end


  # GET /tasks/new
  def new
    @task = Task.new
    @working_group_names_and_ids = @circle.working_groups.map{|wg| [wg.name, wg.id]}
  end

  # GET /tasks/1/edit
  def edit
    @working_group_names_and_ids = @circle.working_groups.map{|wg| [wg.name, wg.id]}
  end

  # POST /tasks
  # POST /tasks.json
  def create
    task_params.require(:name)
    task_params.require(:working_group_id)
    @task = Task.new(task_params)

    respond_to do |format|
      if @task.save
        format.html { redirect_to circle_tasks_path(@circle), notice: 'Task was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /tasks/1
  # PATCH/PUT /tasks/1.json
  def update
    respond_to do |format|
      if @task.update(task_params)
        format.html { redirect_to circle_tasks_path(@circle), notice: 'Task was successfully updated.' }
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
      format.html { redirect_to circle_tasks_url(@circle), notice: 'Task was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def ensure_logged_in
    @current_user = current_user || redirect_to(root_path)
  end

  def set_task
    @task = Task.find(params[:id])
  end

  def set_circle
    @circle = Circle.find(params[:circle_id])
  end

    # Never trust parameters from the scary internet, only allow the white list through.
    def task_params
      params[:task].permit(:name, :description, :working_group_id, :due_date)
    end
end
