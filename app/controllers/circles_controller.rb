class CirclesController < ApplicationController
  layout 'internal'

  before_action :ensure_logged_in
  before_action :set_back_path, only: [:show]

  load_and_authorize_resource

  include HasCircle

  def show

    @files              = current_circle.files.select { |f| can?(:read, f) }

    tasks               = current_circle.tasks.not_in_project.ordered_by_date
    @open_tasks         = tasks.not_completed.select { |task| can?(:read, task) }
    @completed_tasks    = tasks.completed.select { |task| can?(:read, task) }

    supplies            = current_circle.supplies.not_in_project.ordered_by_date
    @open_supplies      = supplies.not_completed.select { |supply| can?(:read, supply) }
    @completed_supplies = supplies.completed.select { |supply| can?(:read, supply) }

    sorter              = lambda { |project| project.due_date || Date.today }
    projects            = current_circle.projects
    @open_projects      = projects.open.select { |project| can?(:read, project) }.sort_by(&sorter)
    @completed_projects = projects.completed.select { |project| can?(:read, project) }.sort_by(&sorter)
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
