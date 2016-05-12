class AddStatusToUsers < ActiveRecord::Migration
  
  USER_STATUS_ACTIVE = 1
  
  def change
    add_column :users, :status, :integer
    User.update_all(status: USER_STATUS_ACTIVE)
  end
end
