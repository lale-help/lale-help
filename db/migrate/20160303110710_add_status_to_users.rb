class AddStatusToUsers < ActiveRecord::Migration
  def change
    User.update_all(:status => :active)
    add_column :users, :status, :integer
  end
end
