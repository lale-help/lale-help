class MoveUserStatusToCircleRole < ActiveRecord::Migration

  def up
    add_column :circle_roles, :status, :integer
    User.find_each do |user|
      status_id = User.statuses[user.status]
      user.circle_roles.each { |role| role.update_attribute(:status, status_id) }
    end
    remove_column :users, :status
  end

  def down
    add_column :users, :status, :integer
    User.find_each do |user|
      status = user.circle_roles.pluck(:status).include?(User.statuses[:pending]) ? :pending : :active
      status_id = User.statuses[status]
      user.update_attribute(:status, status_id)
    end
    remove_column :circle_roles, :status
  end
end
