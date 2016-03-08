class AddIsPrivateToWorkingGroups < ActiveRecord::Migration
  def change
    add_column :working_groups, :is_private, :boolean, default: false
  end
end
