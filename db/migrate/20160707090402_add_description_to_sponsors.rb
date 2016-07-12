class AddDescriptionToSponsors < ActiveRecord::Migration
  def change
    add_column :sponsors, :description, :text
  end
end
