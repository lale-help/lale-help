class Task < ActiveRecord::Base
  include Taskable
  include Completable
  include Commentable
  include Skillable

  # Associations
  has_many :location_assignments
  has_many :locations, through: :location_assignments

  # Enums
  enum duration: [:hours_1, :hours_2, :hours_3, :half_day, :all_day]

  # wrapping the attribute in a StringEnquirer allows task.scheduling_type.between?,
  # but still returns "between" for task.scheduling_type
  def scheduling_type
    read_attribute(:scheduling_type).try(:inquiry)
  end

  def primary_location
    locations.where(task_location_assignments:{ primary: true}).first
  end

  def primary_location=(new_location)
    location_assignments.create(primary: true, location: new_location)
  end

  def extra_locations
    locations.where(task_location_assignments:{ primary: false})
  end

  def missing_volunteer_count
    volunteer_count_required - volunteers.size
  end

  def on_track?
    completed_at? || (missing_volunteer_count <= 0)
  end

  def is_missing_volunteers?
    !on_track?
  end

end
