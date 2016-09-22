class AddNameUniquenessIndexToCircles < ActiveRecord::Migration
  def change
    add_index :circles, :name, unique: true
  end
end
