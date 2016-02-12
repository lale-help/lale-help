class CirclesController < ApplicationController
  layout 'internal'

  before_action :ensure_logged_in, except: :index
  load_and_authorize_resource

  include HasCircle

  def show
    @open_tasks = current_circle.tasks.not_completed.order(due_date: :asc)
    @open_supplies = current_circle.supplies.not_completed.order(due_date: :asc)
  end

  def update
    authorize! :manage, current_circle

    @form = Circle::Update.new(params[:circle], user: current_user, circle: current_circle)

    outcome = @form.submit

    if outcome.success?
      redirect_to circle_admin_path(current_circle), notice: t('flash.updated', name: Circle.model_name.human)

    else
      redirect_to circle_admin_path(current_circle), notice: t('flash.failed', name: Circle.model_name.human)
    end
  end

end
