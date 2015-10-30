class CleanupSchema < ActiveRecord::Migration
  def change
    remove_column :users, :email
    remove_column :users, :circle_id

    drop_table :task_volunteer_assignments
    drop_table :user_feedbacks
  end
end
