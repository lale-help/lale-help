class Circle::TaskablesController < ApplicationController
  layout "internal"
  before_action :ensure_logged_in
  before_action :set_back_path, only: [:volunteering, :organizing]

  include HasCircle

  def volunteer
    authorize! :read, current_circle
    @tasks = current_user.tasks.for_circle(current_circle).volunteered.not_completed.ordered_by_date
    @supplies = current_user.supplies.for_circle(current_circle).volunteered.not_completed.ordered_by_date
  end


  def organizer
    authorize! :read, current_circle
    @tasks = current_user.tasks.for_circle(current_circle).organized.not_completed.ordered_by_date
    @supplies = current_user.supplies.for_circle(current_circle).organized.not_completed.ordered_by_date
  end

end
