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
    @open_supplies = current_circle.supplies.not_completed.ordered_by_date.select do |supply|
      can? :read, supply
    end
    @files = current_circle.files.select{|f| can?(:read, f)}
  end

  def update
    authorize! :manage, current_circle

    @form = form_for_update

    outcome = @form.submit

    if outcome.success?
      redirect_to @form.redirect_path, notice: t('flash.updated', name: Circle.model_name.human)
    else
      flash.now[:error] = t('flash.failed.update', name: Circle.model_name.human)
      errors.add outcome.errors
      render @form.view_for_error
    end
  end


  # TODO: move to page object
  helper_method def tab_class key
    'selected' if key == 'show'
  end

  private

  def form_for_update
    klass = params[:circle][:must_activate_users] ? Circle::UpdateExtendedSettingsForm : Circle::UpdateBasicSettingsForm
    klass.new(params[:circle], user: current_user, circle: current_circle)
  end

end