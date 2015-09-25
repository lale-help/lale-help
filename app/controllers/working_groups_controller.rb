class WorkingGroupsController < ApplicationController
  layout 'circle_page'

  before_action :set_circle
  before_action :set_working_group, only: [:show, :edit, :update, :destroy]

  # GET /working_groups
  # GET /working_groups.json
  def index
    @working_groups = @circle.working_groups
  end

  # GET /working_groups/1
  # GET /working_groups/1.json
  def show
  end

  # GET /working_groups/new
  def new
    @working_group = @circle.working_groups.build
    render layout: 'form_layout'
  end

  # GET /working_groups/1/edit
  def edit
    render layout: 'form_layout'
  end

  # POST /working_groups
  # POST /working_groups.json
  def create
    @working_group = @circle.working_groups.build(working_group_params)

    respond_to do |format|
      if @working_group.save
        format.html { redirect_to [@circle, @working_group], notice: 'Working group was successfully created.' }
        format.json { render :show, status: :created, location: @working_group }
      else
        format.html { render :new }
        format.json { render json: @working_group.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /working_groups/1
  # PATCH/PUT /working_groups/1.json
  def update
    respond_to do |format|
      if @working_group.update(working_group_params)
        format.html { redirect_to [@circle, @working_group], notice: 'Working group was successfully updated.' }
        format.json { render :show, status: :ok, location: @working_group }
      else
        format.html { render :edit }
        format.json { render json: @working_group.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /working_groups/1
  # DELETE /working_groups/1.json
  def destroy
    @working_group.destroy
    respond_to do |format|
      format.html { redirect_to working_groups_url, notice: 'Working group was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

    def set_circle
      @circle = Circle.includes(:working_groups).find(params[:circle_id])
    end

  # Use callbacks to share common setup or constraints between actions.
    def set_working_group
      @working_group = @circle.working_groups.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def working_group_params
      params[:working_group].permit(:name)
    end
end
