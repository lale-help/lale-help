class AddCirleToVolunteer < ActiveRecord::Migration
  def change
    add_column :volunteers, :circle_id, :integer, limit: 8
  end
end
