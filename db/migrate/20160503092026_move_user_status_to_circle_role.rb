class MoveUserStatusToCircleRole < ActiveRecord::Migration

  STATUS_MAP = %i(pending active blocked)

  def up
    add_column :circle_roles, :status, :integer
    User.find_each do |user|
      status_id = STATUS_MAP.index(user.status)
      user.circle_roles.each { |role| role.update_attribute(:status, status_id) }
    end
    remove_column :users, :status
  end

  def down
    add_column :users, :status, :integer
    User.find_each do |user|
      status_id = STATUS_MAP.index(:active) # hard fix
      user.update_attribute(:status, status_id)
    end
    remove_column :circle_roles, :status
  end
end
