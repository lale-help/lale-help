class Volunteer < ActiveRecord::Base
  has_many :feedback

  has_many :task_volunteer_assignments, class_name: '::Task::VolunteerAssignment'
  has_many :tasks, through: :task_volunteer_assignments

  has_many :discussion_messages, class_name: '::Discussion::Message'

  has_many :discussion_watchings, class_name: '::Discussion::Watcher'
  has_many :watched_discussions, through: :discussion_watchings, source: :discussion, class_name: '::Discussion'

  has_many :triggered_system_events, class_name: '::SystemEvent'
  has_many :notifications, class_name: '::SystemEvent::Notification'
end
