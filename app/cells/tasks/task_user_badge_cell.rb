#  FIXME There’s a nasty bug when rendering the Tasks::UserBadgeCell: _sometimes_ it wouldn’t 
#  set the class „unassignable“ correctly. I *assume* this happens because the wrong
#  class is loaded/used, i.e. ::UserBadgeCell instead of Tasks::::UserBadgeCell. 
#  Since I can’t thoroughly debug, I’m renaming the class for now, hoping this will fix the bug.
#  
class Tasks::TaskUserBadgeCell < ::UserBadgeCell

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
