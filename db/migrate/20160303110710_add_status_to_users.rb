class AddStatusToUsers < ActiveRecord::Migration
  def change
    add_column :users, :status, :integer
    User.update_all(:status => :active)
  end
end
