class AddStatusToWorkingGroups < ActiveRecord::Migration

  WG_STATUS_ACTIVE = 0

  def up
    add_column :working_groups, :status, :integer, default: WG_STATUS_ACTIVE
    WorkingGroup.update_all(status: WG_STATUS_ACTIVE)
  end

  def down
    remove_column :working_groups, :status
  end

end
