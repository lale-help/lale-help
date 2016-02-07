class AddDescriptionToWorkingGroups < ActiveRecord::Migration
  def change
    add_column :working_groups, :description, :string
  end
end
