# FIXME put this in a page object
module AdminActionsHelper

  def pending_admin_actions_count
    current_circle.users.pending.count
  end

  def pending_admin_actions?
    pending_admin_actions_count > 0
  end

end