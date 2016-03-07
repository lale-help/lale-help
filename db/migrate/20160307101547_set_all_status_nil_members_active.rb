class SetAllStatusNilMembersActive < ActiveRecord::Migration
  def change
    User.where(status: nil).update_all(:status => User.statuses[:active])
  end
end
