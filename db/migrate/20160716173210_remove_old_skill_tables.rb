class RemoveOldSkillTables < ActiveRecord::Migration

  def up
    # these had been created but weren't used
    drop_table :task_skill_assignments
    drop_table :task_skills
  end
  
end
