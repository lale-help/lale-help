# this is the join table between
# - skill and 
# - task, user or circle (it's polymorphic)
#
# * Finding suitable helpers for a task by skill:
# required_skill_keys = Task.last.skills.map(&:key)
# user_hashes = SkillAssignment.where("skill_key IN (?) AND skillable_type=?", required_skill_keys, 'User').group(:skillable_id).order("count_skillable_id DESC").count(:skillable_id)
# => {7=>2, 1=>1} # {user_id => count, ... }
# 
class SkillAssignment < ActiveRecord::Base
  
  validates :skill_key, presence: true
  validates :skill_key, uniqueness: { scope: [:skillable_id, :skillable_type] }

  validates :skillable_id, presence: true
  validates :skillable_type, presence: true

  # "skillable" is a thing that has or requires skills; currently a user, task or circle
  belongs_to :skillable, polymorphic: true
  
  def skill
    Skill.find_by_key(skill_key)
  end

  # FIXME move to mutation Circle::Create
  def self.create_defaults_for_circle(circle)
    Skill.defaults.each do |_, skill_keys|
      skill_keys.each { |key| create!(skill_key: key, skillable: circle) }
    end
  end
end
