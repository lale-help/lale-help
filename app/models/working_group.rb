class WorkingGroup < ActiveRecord::Base
  has_many :volunteer_memberships
  has_many :volunteers, through: :volunteer_memberships

  has_many :tasks
  has_many :discussions
  belongs_to :circle
end
