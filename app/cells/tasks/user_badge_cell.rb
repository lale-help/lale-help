class Tasks::UserBadgeCell < ::UserBadgeCell

  def task
    @options[:task]
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

end
