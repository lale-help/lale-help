class CirclesController < ApplicationController
  layout 'internal'

  before_action :ensure_logged_in
  before_action :set_back_path, only: [:show]

  load_and_authorize_resource

  include HasCircle


  def show
    @open_tasks = current_circle.tasks.not_completed.ordered_by_date.select do |task|
      can? :read, task
    end
    @completed_tasks = current_circle.tasks.completed.ordered_by_date.select do |task|
      can? :read, task
    end
    @open_supplies = current_circle.supplies.not_completed.ordered_by_date.select do |supply|
      can? :read, supply
    end
    @completed_supplies = current_circle.supplies.completed.ordered_by_date.select do |supply|
      can? :read, supply
    end
  end

  def update
    authorize! :manage, current_circle

    @form = Circle::Update.new(params[:circle], user: current_user, circle: current_circle)

    outcome = @form.submit

    if outcome.success?
      redirect_to circle_admin_path(current_circle), notice: t('flash.updated', name: Circle.model_name.human)
    else
      flash.now[:error] = t('flash.failed.update', name: Circle.model_name.human)
      errors.add outcome.errors
      render 'circle/admins/show'
    end
  end


  # TODO: move to page object
  helper_method def tab_class key
    'selected' if key == 'show'
  end

end
