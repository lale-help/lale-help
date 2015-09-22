class Task::SkillAssignment < ActiveRecord::Base
  belongs_to :skill
  belongs_to :task
end
