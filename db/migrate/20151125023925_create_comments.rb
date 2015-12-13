class CreateComments < ActiveRecord::Migration
  def up
    create_table :comments do |t|
      t.references :commenter, index: true, null: false, limit: 8
      t.references :task, index: true, polymorphic: true, null: false
      t.text :body

      t.timestamps null: false
    end
    change_column :comments, :id, :integer, limit: 8
    change_column :comments, :task_id, :integer, limit: 8
  end

  def down
    drop_table :comments
  end
end
