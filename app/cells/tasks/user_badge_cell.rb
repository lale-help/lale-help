class Tasks::UserBadgeCell < ::ViewModel

  include LinksHelper

  alias :user :model

  delegate :can?, to: :ability

  def show
    render
  end

  def user_link
    link_to_user(user)
  end

  def task
    @options[:task]
  end

  def current_user
    @options[:current_user]
  end

  def current_circle
    task.circle
  end

  def user_badge_attributes
    {
      data: {
        'unassign-action': unassign_user_path, 
        'unassign-method': 'PUT'
      },
      class: can?(:unassign, task) ? 'unassignable' : ''
    }
  end

  def unassign_user_path
    circle_task_unassign_volunteer_path(task.circle, task, user_id: user.id)
  end

  def ability
    @ability ||= Ability.new(current_user)
  end

end
