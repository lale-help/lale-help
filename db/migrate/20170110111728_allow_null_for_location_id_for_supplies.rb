class AllowNullForLocationIdForSupplies < ActiveRecord::Migration
  def change
    change_column :supplies, :location_id, :integer, null: true
  end
end
