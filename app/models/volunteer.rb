class Volunteer < ActiveRecord::Base
  has_many :feedback

  has_many :task_volunteer_assignments, class_name: '::Task::VolunteerAssignment'
  has_many :tasks, through: :task_volunteer_assignments

  has_many :triggered_system_events, class_name: '::SystemEvent'
  has_many :notifications, class_name: '::SystemEvent::Notification'

  has_many :identities

  belongs_to :location
  belongs_to :circle

  def name
    "#{first_name} #{last_name}"
  end
end
