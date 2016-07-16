# this is the join table between
# - skill and 
# - task, user or circle (it's polymorphic)
#
# * Finding suitable helpers for a task by skill:
# required_skill_ids = Task.last.skill_ids
# user_hashes = SkillAssignment.where("skill_id IN (?) AND skillable_type=?", required_skill_ids, 'User').group(:skillable_id).order("count_skillable_id DESC").count(:skillable_id)
# => {7=>2, 1=>1} # {user_id => count, ... }
# 
class SkillAssignment < ActiveRecord::Base
  
  validates :skill_id, presence: true
  validates :skill_id, uniqueness: { scope: [:skillable_id, :skillable_type] }

  validates :skillable_id, presence: true
  validates :skillable_type, presence: true

  belongs_to :skill
  # "skillable" is a thing that has or requires skills; currently a user, task or circle
  belongs_to :skillable, polymorphic: true
  
  # FIXME move to mutation Circle::Create
  def self.create_initial_assignments_for_circle(circle)
    Skill.defaults.each do |category, skills|
      skills.each { |skill| create!(skill: skill, skillable: circle) }
    end
  end
end
