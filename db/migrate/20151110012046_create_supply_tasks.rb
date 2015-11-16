class CreateSupplyTasks < ActiveRecord::Migration
  def change
    create_table :supplies do |t|
      t.string :name
      t.string :description

      t.integer :working_group_id
      t.integer :location_id, null: false, limit: 8

      t.date :due_date
      t.datetime :completed_at

      t.timestamps null: false
    end

    create_table :supply_roles do |t|
      t.integer :role_type,       null: false
      t.integer :user_id,         null: false, limit: 8
      t.integer :supply_id,  null: false, limit: 8

      t.timestamps null: false
    end
  end
end
