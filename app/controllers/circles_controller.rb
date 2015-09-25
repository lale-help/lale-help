class CirclesController < ApplicationController
  layout 'circle_page'

  before_action :set_circle, only: [:show, :edit, :update, :destroy]

  # GET /circles
  # GET /circles.json
  def index
    @center = params[:location].present? ? Location.location_from(params[:location]) : current_user.location
    locations = Location.near(@center).to_a
    @circles = Circle.where(location: locations.uniq)
    respond_to do |format|
      format.html
      format.json { render layout: false }
    end
  end

  # GET /circles/1
  # GET /circles/1.json
  def show
  end

  # GET /circles/new
  def new
    @circle = Circle.new
    render layout: 'form_layout'
  end

  # GET /circles/1/edit
  def edit
    render layout: 'form_layout'
  end

  # POST /circles
  # POST /circles.json
  def create
    circle_params.require(:name)
    circle_params.require(:location_text)
    @circle = Circle.new(circle_params)

    respond_to do |format|
      if @circle.save
        format.html { redirect_to @circle, notice: 'Circle was successfully created.' }
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
        format.html { redirect_to @circle, notice: 'Circle was successfully updated.' }
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
      format.html { redirect_to circles_url, notice: 'Circle was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_circle
      @circle = Circle.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def circle_params
      params[:circle].permit(:name, :location_text).merge(admin_id: current_user.id)
    end
end
