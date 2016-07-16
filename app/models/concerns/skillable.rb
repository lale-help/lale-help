module Skillable

  extend ActiveSupport::Concern

  included do
    has_many :skill_assignments, as: :skillable, dependent: :destroy
  end

  # assign new skills with:
  # @skillable.skill_assignments.create!(skill_key: "de")
  def skills
    keys = skill_assignments.pluck(:skill_key)
    Skill.find_all_by_key(keys)
  end
end