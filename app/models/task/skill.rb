class Task::Skill < ActiveRecord::Base
  has_many :task_skill_assignments
  has_many :tasks, through: :task_skill_assignments
end
