class Tasks::SourcingWidgetCell < ::ViewModel

  include ActionView::Helpers::FormOptionsHelper

  # the first argument to the #cell call is "model" in here
  alias :task :model 

  delegate :can?, 
    to: :ability

  delegate :is_missing_volunteers?, :volunteer_count_required, :volunteers,
    to: :task

  def show
    render
    #render + "<hr style='margin:25px' />" + render('show_new')
  end

  private

  def title
    string = t(".volunteer-count-required", count: volunteer_count_required)
    if is_missing_volunteers?
      string << t(".volunteer-count-missing", count: task.missing_volunteer_count)
    end
    string
  end

  def current_user
    @options[:current_user]
  end

  def circle
    task.circle
  end

  def missing_volunteer_count
    can?(:volunteer, task) ? task.missing_volunteer_count - 1 : task.missing_volunteer_count
  end

  def assignable_volunteers_select
    cell('tasks/volunteer_select_tag', task)
  end

  def ability
    @ability ||= Ability.new(current_user)
  end

  def links
    @links ||= begin
      OpenStruct.new(
        decline: circle_task_decline_path(circle, task),
        accept: circle_task_volunteer_path(circle, task),
        invite_wg: circle_task_invite_path(circle, task, type: 'working_group'),
        invite_circle: circle_task_invite_path(circle, task, type: 'circle')
      )
    end
  end

end
