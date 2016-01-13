class AddLastloginToUser < ActiveRecord::Migration
  def change
    add_column :users, :last_login, :datetime
  end
end
