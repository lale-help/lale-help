class RemoveLocationFromCircles < ActiveRecord::Migration
  def change
    remove_column :circles, :location_id
  end
end
