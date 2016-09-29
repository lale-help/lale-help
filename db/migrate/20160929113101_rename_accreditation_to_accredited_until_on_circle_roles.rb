class RenameAccreditationToAccreditedUntilOnCircleRoles < ActiveRecord::Migration

  def change
    remove_column :circle_roles, :accredited, :boolean
    add_column    :circle_roles, :accredited_until, :date
  end

end
