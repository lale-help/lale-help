class Task < ActiveRecord::Base
  include Taskable
  include Completable

  # Associations
  has_many :location_assignments
  has_many :locations, through: :location_assignments

  # Enums
  enum duration: [:hours_1, :hours_2, :hours_3, :half_day, :all_day]

  # enables task.scheduling_type.between? & friends
  # but task.scheduling_type still returns 'between'.
  def scheduling_type
    read_attribute(:scheduling_type).inquiry
  end

  def primary_location
    locations.where(task_location_assignments:{ primary: true}).first
  end

  def extra_locations
    locations.where(task_location_assignments:{ primary: false})
  end

  def due_date_and_time
    I18n.l(due_date, format: "%A %-d %B %Y") + " " + scheduled_time
  end

  # FIXME adapt
  def scheduled_time
    I18n.t("activerecord.attributes.task.scheduled-time.#{scheduling_type}", start: start_time, end: due_time)
  end

  def duration_text
    I18n.t("activerecord.attributes.task.duration-text.#{duration}")
  end
end
