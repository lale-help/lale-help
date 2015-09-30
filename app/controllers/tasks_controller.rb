class TasksController < ApplicationController
  layout "circle_page"
  before_action :ensure_logged_in
  load_and_authorize_resource :circle
  load_and_authorize_resource through: :circle, except: [:volunteer, :new]

  # GET /tasks
  # GET /tasks.json
  def index
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
        format.html { redirect_to @circle, notice: 'Task was successfully created.' }
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
        format.html { redirect_to [@circle], notice: 'Task was successfully updated.' }
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
      format.html { redirect_to [@circle], notice: 'Task was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def volunteer
    @task = @circle.tasks.find(params[:task_id])
    @task.volunteers << current_user
    if @task.save
      redirect_to [@circle], notice: "Thanks for volunteering for #{@task.name}!"
    else
      redirect_to [@circle], alert: 'Sorry, something went wrong'
    end
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def task_params
      params[:task].permit(:name, :description, :working_group_id, :due_date, :complete)
    end
end
