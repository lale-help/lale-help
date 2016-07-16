class CreateSkillsTables < ActiveRecord::Migration
  def change

    create_table :skills do |t|
      t.string :category, index: true
      t.string :key
      t.boolean :default
      t.index [:category, :key], unique: true
    end

    create_table :skill_assignments do |t|
      t.integer :skill_id
      t.integer :skillable_id
      t.string :skillable_type
      t.index [:skillable_id, :skillable_type]
      t.index [:skill_id, :skillable_id, :skillable_type], unique: true, name: 'index_unique_skill_skillable'
    end

  end
end
