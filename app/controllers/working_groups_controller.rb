class WorkingGroupsController < ApplicationController
  layout 'circle_page'
  before_action :ensure_logged_in
  load_and_authorize_resource :circle
  load_and_authorize_resource through: :circle

  # GET /working_groups
  # GET /working_groups.json
  def index
  end

  # GET /working_groups/1
  # GET /working_groups/1.json
  def show
  end

  # GET /working_groups/new
  def new
    render layout: 'form_layout'
  end

  # GET /working_groups/1/edit
  def edit
    render layout: 'form_layout'
  end

  # POST /working_groups
  # POST /working_groups.json
  def create
    respond_to do |format|
      if @working_group.save
        format.html { redirect_to [@circle], notice: t('flash.created', name: 'Working group') }
      else
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /working_groups/1
  # PATCH/PUT /working_groups/1.json
  def update
    respond_to do |format|
      if @working_group.update(working_group_params)
        format.html { redirect_to [@circle], notice: t('flash.updated', name: 'Working group') }
      else
        format.html { render :edit }
      end
    end
  end

  # DELETE /working_groups/1
  # DELETE /working_groups/1.json
  def destroy
    @working_group.destroy
    respond_to do |format|
      format.html { redirect_to @circle, notice: t('flash.destroyed', name: 'Working group') }
      format.json { head :no_content }
    end
  end

  private
      # Never trust parameters from the scary internet, only allow the white list through.
    def working_group_params
      params[:working_group].permit(:name)
    end
end
