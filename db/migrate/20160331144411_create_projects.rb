class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :name
      t.text :description
      t.integer :working_group_id
      t.timestamps null: false
    end

    add_column :tasks, :project_id, :integer
    add_column :supplies, :project_id, :integer
  end
end
