class AddDescriptionToCircles < ActiveRecord::Migration
  def change
    add_column :circles, :description, :string
  end
end
