class AddAccreditationToCircleRoles < ActiveRecord::Migration
  def change
    add_column :circle_roles, :accredited, :boolean, default: false
  end
end
