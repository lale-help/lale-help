class Circle::SuppliesController < ApplicationController
  layout "internal"
  before_action :ensure_logged_in
  before_action :set_back_path, only: [:index]

  include HasCircle

  def index
    authorize! :read, current_circle

    @supplies = current_circle.supplies.not_completed.ordered_by_date.select do |supply|
      can? :read, supply
    end
  end

  def show
    authorize! :read, current_supply
    if can? :create, Comment, current_supply
      @form = Comment::Create.new(commenter: current_user, task: current_supply, comment: Comment.new)
    end
  end


  def new
    authorize! :create_supply, current_circle
    @form = Supply::Create.new(user: current_user, circle: current_circle, ability: current_ability, project_id: params[:project_id])
  end


  def edit
    authorize! :update, current_supply
    @form = Supply::Update.new(current_supply, user: current_user, supply: current_supply, circle: current_circle, ability: current_ability)
  end


  def create
    authorize! :create_supply, current_circle

    @form = Supply::Create.new(params[:supply], user: current_user, circle: current_circle, ability: current_ability)

    outcome = @form.submit

    if outcome.success?
      redirect_to circle_supply_path(current_circle, outcome.result), notice: t('flash.created', name: Supply.model_name.human)

    else
      errors.add outcome.errors

      render :new
    end
  end


  def update
    authorize! :update, current_supply

    @form = Supply::Update.new(params[:supply], user: current_user, supply: current_supply, circle: current_circle, ability: current_ability)

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

    Supply::Destroy.run(supply: current_supply, user: current_user)

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
      redirect_to circle_supply_path(current_circle, current_supply), notice: t('supplies.flash.declined', name: current_supply.name)
    else
      puts outcome.errors
      redirect_to circle_supply_path(current_circle, current_supply), alert: t('supplies.flash.decline_failed', name: current_supply.name)
    end
  end


  # TODO extract to an InvitationsController (which can then also be used by the other resources that need invitations)
  def invite
    authorize! :invite_to, current_supply

    outcome = Supply::Notifications::InvitationEmail.run(current_user: current_user, supply: current_supply, type: params[:type])

    if outcome.success?
      redirect_to circle_supply_path(current_circle, current_supply), notice: t('supplies.flash.invited', name: current_supply.name)
    else
      redirect_to circle_supply_path(current_circle, current_supply), alert: t('supplies.flash.invite_failed', name: current_supply.name)
    end
  end


  def reopen
    authorize! :reopen, current_supply

    outcome = Supply::Reopen.run(user: current_user, supply: current_supply)

    if outcome.success?
      redirect_to circle_supply_path(current_circle, current_supply), notice: t('supplies.flash.reopened', name: current_supply.name)
    else
      redirect_to circle_supply_path(current_circle, current_supply), alert: t('supplies.flash.reopening_failed', name: current_supply.name)
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
