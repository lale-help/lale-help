class Volunteer < ActiveRecord::Base
  has_many :feedback, class_name: '::VolunteerFeedback'

  has_many :working_group_memberships, class_name: '::WorkingGroupVolunteer'
  has_many :working_groups, through: :working_group_memberships

  has_many :task_assignments, class_name: '::TaskVolunteer'
  has_many :tasks, through: :task_assignments

  has_many :discussion_messages

  has_many :discussion_watchings, class_name: '::DiscussionWatcher'
  has_many :watched_discussions, through: :discussion_watchings, source: :discussion, class_name: '::Discussion'

  has_many :triggered_system_events, class_name: '::SystemEvent'
  has_many :notifications, class_name: '::SystemEventNotification'
end
