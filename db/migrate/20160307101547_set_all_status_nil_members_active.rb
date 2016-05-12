class SetAllStatusNilMembersActive < ActiveRecord::Migration

  USER_STATUS_ACTIVE = 1

  def change
    User.where(status: nil).update_all(:status => USER_STATUS_ACTIVE)
  end
end
