class User < ActiveRecord::Base
  enum status: %i(pending active blocked)
end

class Circle::Role < ActiveRecord::Base
  enum status: %i(pending active blocked)
end

class MoveUserStatusToCircleRole < ActiveRecord::Migration

  def up
    add_column :circle_roles, :status, :integer
    User.find_each do |user|
      if user.status
        user.circle_roles.each { |role| role.update_attribute(:status, user.status) }
      else 
        puts "User #{user.id} has status nil, not updating status on circle roles."
      end
    end
    remove_column :users, :status
  end

  def down
    add_column :users, :status, :integer
    User.find_each do |user|
      if user.circle_roles.present?
        status = user.circle_roles.present? && user.circle_roles.all?(&:active?) ? :active : :pending
        user.update_attribute(:status, status)
      else
        user.update_attribute(:status, nil)
      end
    end
    remove_column :circle_roles, :status
  end

end
