class Task < ActiveRecord::Base
  # Associations
  belongs_to :working_group
  has_one :circle, through: :working_group

  has_many :roles

  has_many :users,      ->{ distinct                    }, through: :roles
  has_many :volunteers, ->{ Role.send('task.volunteer') }, through: :roles, source: :user
  has_many :organizers,  ->{ Role.send('task.organizer') }, through: :roles, source: :user

  has_many :location_assignments
  has_many :locations, through: :location_assignments


  # Scopes
  scope :completed,     -> { where("completed_at IS NOT NULL") }
  scope :not_completed, -> { where("completed_at IS NULL") }

  scope :for_circle, ->(circle) { where(working_group: circle.working_groups) }


  # Validations
  validates :name, presence: true
  validates :due_date, presence: true
  validates :description, presence: true
  validates :working_group, presence: true


  def primary_location
    locations.where(task_location_assignments:{ primary: true}).first
  end

  def extra_locations
    locations.where(task_location_assignments:{ primary: false})
  end


  def complete= val
    self.completed_at = Time.now if val.to_s == "true"
  end

  def complete?
    completed_at.present?
  end

  def incomplete?
    !complete?
  end

  def due_date_and_time
    due_date.strftime("%A %-d %B %Y") + " " + scheduled_time_string
  end

  def scheduled_time_string
    case scheduled_time_type
    when 'at' then "at #{scheduled_time_start}"
    when 'between' then "between #{scheduled_time_start} and #{scheduled_time_end}"
    else ""
    end
  end

  def organizer
    @organizer ||= organizers.first
  end
end
