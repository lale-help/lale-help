module Skillable

  extend ActiveSupport::Concern

  included do
    has_many :skill_assignments, as: :skillable, dependent: :destroy
    has_many :skills, through: :skill_assignments
  end

end