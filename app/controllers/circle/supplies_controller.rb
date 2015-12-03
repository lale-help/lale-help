class Circle::SuppliesController < ApplicationController
  layout "internal"
  before_action :ensure_logged_in

  include HasCircle

  def index
    authorize! :read, current_circle

    @supplies = current_circle.supplies.not_completed.order('due_date asc').limit(10)
  end

  def show
    authorize! :read, current_supply

    page.task_css = "complete" if current_supply.complete?

    if can? :create, Comment, current_supply
      @form = Comment::Create.new(commenter: current_user, task: current_supply, comment: Comment.new)
    end
  end


  def new
    authorize! :create_supply, current_circle
    @supply = @circle.working_groups.first.supplies.build
    @form = Supply::Create.new(current_supply, user: current_user, supply: current_supply)
  end


  def edit
    authorize! :update, current_supply
    @form = Supply::Update.new(current_supply, user: current_user, supply: current_supply)
  end


  def create
    working_group = current_circle.working_groups.find(params[:supply][:working_group_id])
    authorize! :create_supply, working_group

    @supply = Supply.new
    @form = Supply::Create.new(params[:supply], user: current_user, supply: @supply, working_group: working_group)

    outcome = @form.submit

    if outcome.success?
      redirect_to circle_supply_path(current_circle, outcome.result), notice: t('flash.created', name: Supply.model_name.human)

    else
      errors.add outcome.errors

      render :new
    end
  end


  def update
    working_group = current_circle.working_groups.find(params[:supply][:working_group_id])

    authorize! :update, current_supply

    @form = Supply::Update.new(params[:supply], user: current_user, supply: current_supply, working_group: working_group)

    outcome = @form.submit

    if outcome.success?
      redirect_to circle_supply_path(current_circle, outcome.result), notice: t('flash.updated', name: Supply.model_name.human)

    else
      errors.add outcome.errors
      render :edit
    end
  end


  def destroy
    authorize! :destroy, current_supply

    outcome = Supply::Destroy.run(supply: current_supply, user: current_user)

    redirect_to circle_supplies_path(current_circle), notice: t('flash.destroyed', name: Supply.model_name.human)
  end


  def complete
    authorize! :complete, current_supply

    outcome = Supply::Complete.run(user: current_user, supply: current_supply)

    if outcome.success?
      redirect_to circle_supply_path(current_circle, current_supply), notice: t('supplies.flash.completed', name: current_supply.name)
    else
      redirect_to circle_supply_path(current_circle, current_supply), alert: t('supplies.flash.complete_failed', name: current_supply.name)
    end
  end

  def volunteer
    authorize! :volunteer, current_supply

    outcome = Supply::Volunteer.run(user: current_user, supply: current_supply)

    if outcome.success?
      redirect_to circle_supply_path(current_circle, current_supply), notice: t('supplies.flash.volunteered', name: current_supply.name)
    else
      redirect_to circle_supply_path(current_circle, current_supply), alert: t('supplies.flash.volunteer_failed', name: current_supply.name)
    end
  end

  def decline
    authorize! :decline, current_supply

    outcome = Supply::Decline.run(user: current_user, supply: current_supply)

    if outcome.success?
      redirect_to circle_supply_path(current_circle, current_supply), notice: t('supplies.flash.volunteered', name: current_supply.name)
    else
      puts outcome.errors
      redirect_to circle_supply_path(current_circle, current_supply), alert: t('supplies.flash.volunteer_failed', name: current_supply.name)
    end
  end


  helper_method def errors
    @errors ||= Errors.new
  end

  helper_method def current_supply
    @supply ||= Supply.find(params[:id] || params[:supply_id])
  end

  helper_method def page
    @page ||= OpenStruct.new
  end
end
