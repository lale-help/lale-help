class SetCircleRoleActiveByDefault < ActiveRecord::Migration
  def up
    change_column_default :circle_roles, :status, 1
  end
  def down
    change_column_default :circle_roles, :status, nil
  end
end
