class CirclesController < ApplicationController
  layout 'internal'

  before_action :ensure_logged_in
  load_and_authorize_resource

  include HasCircle

  def show
    @open_tasks = current_circle.tasks.not_completed.ordered_by_date.select do |task|
      can? :read, task
    end
    @open_supplies = current_circle.supplies.not_completed.ordered_by_date.select do |supply|
      can? :read, supply
    end
  end

  def update
    authorize! :manage, current_circle

    @form = Circle::UpdateForm.new(params[:circle], user: current_user, circle: current_circle)

    outcome = @form.submit

    if outcome.success?
      redirect_to redirect_path_after_update, notice: t('flash.updated', name: Circle.model_name.human)
    else
      flash.now[:error] = t('flash.failed.update', name: Circle.model_name.human)
      errors.add outcome.errors
      render view_for_update_error
    end
  end


  # TODO: move to page object
  helper_method def tab_class key
    'selected' if key == 'show'
  end

  private

  # FIXME discuss Phil/Phil if these would be ok on the mutation object, and if mutation objects 
  # should be used for different actions (basic settings, extended settings).
  def redirect_path_after_update
    if params[:circle][:must_activate_users]
      extended_settings_circle_admin_path(current_circle)
    else
      circle_admin_path(current_circle)
    end
  end

  # FIXME see above
  def view_for_update_error
    params[:circle][:must_activate_users] ? 'circle/admins/extended_settings' : 'circle/admins/show'
  end

end