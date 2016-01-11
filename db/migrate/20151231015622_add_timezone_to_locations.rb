class AddTimezoneToLocations < ActiveRecord::Migration
  def up
    add_column :locations, :timezone, :string

    Location.find_in_batches do |batch|
      batch.each do |loc|
        loc.update_timezone
      end
    end
  end


  def down
    remove_column :locations, :timezone, :string
  end

end
