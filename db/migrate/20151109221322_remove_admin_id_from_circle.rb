class RemoveAdminIdFromCircle < ActiveRecord::Migration
  def change
    remove_column :circles, :admin_id
  end
end
