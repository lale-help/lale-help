class AddStatusToUsers < ActiveRecord::Migration
  def change
    add_column :users, :status, :integer
    User.update_all(:status => User.statuses[:active])
  end
end
