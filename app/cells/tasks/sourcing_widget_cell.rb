class Tasks::SourcingWidgetCell < ::ViewModel

  include ActionView::Helpers::FormOptionsHelper

  # the first argument to the #cell call is "model" in here
  alias :task :model 

  delegate :can?, to: :ability

  delegate :is_missing_volunteers?, :volunteer_count_required, :volunteers, :circle, :working_group,
    to: :task

  # deep down the user icon partial is rendered, which uses current_circle.
  # since that partial is used globally I don't want to change the variable name
  alias :current_circle :circle 

  # this is the cells default action, ran when using the cell('path') helper
  def show
    render
  end

  private

  # def title
  #   string = t(".volunteer-count-required", count: volunteer_count_required)
  #   if is_missing_volunteers?
  #     string << t(".volunteer-count-missing", count: task.missing_volunteer_count)
  #   end
  #   string
  # end
  # 
  def helper_stats
    "[ #{volunteers.count} / #{volunteer_count_required} ]"
  end

  def current_user
    @options[:current_user]
  end

  def working_group_invitees_count
    circle.users.active.count - volunteers.count
  end

  def circle_invitees_count
    circle.users.active.count - volunteers.count
  end

  def missing_volunteer_count
    # FIXME I think cancan doesn't work correctly right now
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
        invite_circle: circle_task_invite_path(circle, task, type: 'circle'),
        assign_volunteer: circle_task_assign_volunteer_path(circle, task)
      )
    end
  end

end
