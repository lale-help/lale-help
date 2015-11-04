class CreateRoles < ActiveRecord::Migration
  TABLES = [
    :circle_roles,
    :task_roles,
    :working_group_roles
  ]

  def up
    TABLES.each do |table|
      create_table table do |t|
        create_fields(table, t)
      end

      change_column table, :id, :integer, limit: 8
    end

    add_column :circle_roles, :name, :string
  end

  def down
    TABLES.each do |table|
      drop_table table
    end
  end

  def model_id(table)
    table.to_s.gsub("_roles", "_id").to_sym
  end

  def create_fields(table, t)
    t.integer :role_type,       null: false
    t.integer :user_id,         null: false, limit: 8
    t.integer model_id(table),  null: false, limit: 8

    t.timestamps null: false
  end
end
