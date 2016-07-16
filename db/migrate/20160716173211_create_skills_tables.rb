class CreateSkillsTables < ActiveRecord::Migration
  def change

    create_table :skill_assignments do |t|
      t.string :skill_key, index: true
      t.integer :skillable_id
      t.string :skillable_type
      t.index [:skillable_id, :skillable_type]
      t.index [:skill_key, :skillable_id, :skillable_type], unique: true, name: 'index_unique_skill_skillable'
    end

  end
end
