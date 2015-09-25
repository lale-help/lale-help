class DropDiscussions < ActiveRecord::Migration
  def change
    drop_table :discussions
    drop_table :discussion_messages
    drop_table :discussion_volunteer_watchings
    remove_column :tasks, :discussion_id
  end
end
