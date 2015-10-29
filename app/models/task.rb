class Task < ActiveRecord::Base
  has_many :volunteer_assignments, -> { where(organizer: false) }
  has_many :organizer_assignments, -> { where(organizer: true) } , class_name: 'VolunteerAssignment'

  has_many :volunteers, through: :volunteer_assignments, source: :user, class_name: 'User'
  has_many :organizers, through: :organizer_assignments, source: :user, class_name: 'User'

  belongs_to :working_group

  validates :name, presence: true
  validates :due_date, presence: true
  validates :description, presence: true
  validates :working_group, presence: true

  scope :completed,     -> { where("completed_at IS NOT NULL") }
  scope :not_completed, -> { where("completed_at IS NULL") }

  def complete= val
    self.completed_at = Time.now if val.to_s == "true"
  end

  def complete?
    completed_at.present?
  end
end
