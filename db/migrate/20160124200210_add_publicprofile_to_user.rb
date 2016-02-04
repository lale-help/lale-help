class AddPublicprofileToUser < ActiveRecord::Migration
  def change
    add_column :users, :public_profile, :boolean
  end
end
