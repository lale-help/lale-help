class AddLocationToVolunteer < ActiveRecord::Migration
  def change
    add_column :volunteers, :location_id, :integer, limit: 8
  end
end
