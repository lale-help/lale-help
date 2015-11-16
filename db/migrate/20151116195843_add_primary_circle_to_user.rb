class AddPrimaryCircleToUser < ActiveRecord::Migration
  def up
    add_column :users, :primary_circle_id, :integer, limit: 8
    User.all.each do |u|
      u.primary_circle_id = u.circles.first.id
      u.save
    end
  end

  def down
    remove_column :users, :primary_circle_id
  end
end
