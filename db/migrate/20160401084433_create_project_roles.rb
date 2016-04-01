class CreateProjectRoles < ActiveRecord::Migration
  def change
    create_table :project_roles do |t|
      t.integer :role_type,       null: false
      t.integer :user_id,         null: false, limit: 8
      t.integer :project_id,      null: false, limit: 8
      t.timestamps null: false
    end
  end
end
