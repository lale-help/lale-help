class AddMustActivateUsersToCircles < ActiveRecord::Migration
  def change
    add_column :circles, :must_activate_users, :boolean, default: false
    Circle.update_all(must_activate_users: false)
  end
end
