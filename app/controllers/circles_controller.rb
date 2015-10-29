class CirclesController < ApplicationController
  layout 'internal'

  before_action :ensure_logged_in, except: :index
  load_and_authorize_resource

  include HasCircle


  # GET /circles
  # GET /circles.json
  def index
    @center = params[:location].present? ? Location.location_from(params[:location]) : current_user.location
    locations = Location.near(@center).to_a
    @circles = Circle.where(location: locations.uniq)
    respond_to do |format|
      format.html { redirect_to root_path }
      format.json { render layout: false }
    end
  end

  # GET /circles/1
  # GET /circles/1.json
  def show
    @my_tasks = current_circle.tasks.not_completed.joins(:volunteer_assignments).where(task_volunteer_assignments: { volunteer_id: current_user } )
  end

  # GET /circles/new
  def new
    @circle = Circle.new
    # render layout: 'form_layout'
  end

  # GET /circles/1/edit
  def edit
    # render layout: 'form_layout'
  end

  # POST /circles
  # POST /circles.json
  def create
    @circle = Circle.new(circle_params)

    respond_to do |format|
      if @circle.save
        current_user.update(circle: @circle)
        format.html { redirect_to @circle, notice: t('flash.created', name: Circle.model_name.human) }
        format.json { render :show, status: :created, location: @circle }
      else
        format.html { render :new }
        format.json { render json: @circle.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /circles/1
  # PATCH/PUT /circles/1.json
  def update
    respond_to do |format|
      if @circle.update(circle_params)
        format.html { redirect_to @circle, notice: t('flash.updated', name: Circle.model_name.human) }
        format.json { render :show, status: :ok, location: @circle }
      else
        format.html { render :edit }
        format.json { render json: @circle.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /circles/1
  # DELETE /circles/1.json
  def destroy
    @circle.destroy
    respond_to do |format|
      format.html { redirect_to Circle, notice: t('flash.destroyed', name: Circle.model_name.human) }
      format.json { head :no_content }
    end
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def circle_params
      params[:circle].permit(:name, :location_text).merge(admin_id: current_user.id)
    end
end
