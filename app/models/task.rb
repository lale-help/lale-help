class Task < ActiveRecord::Base
  # Associations
  belongs_to :working_group
  has_one :circle, through: :working_group

  has_many :roles

  has_many :users,      ->{ distinct                    }, through: :roles
  has_many :volunteers, ->{ Role.send('task.volunteer') }, through: :roles, source: :user


  has_many :organizers,  ->{ Role.send('task.organizer') }, through: :roles, source: :user


  # Scopes
  scope :completed,     -> { where("completed_at IS NOT NULL") }
  scope :not_completed, -> { where("completed_at IS NULL") }


  # Validations
  validates :name, presence: true
  validates :due_date, presence: true
  validates :description, presence: true
  validates :working_group, presence: true


  def complete= val
    self.completed_at = Time.now if val.to_s == "true"
  end

  def complete?
    completed_at.present?
  end

  def incomplete?
    !complete?
  end
end
