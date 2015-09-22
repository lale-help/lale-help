class Discussion < ActiveRecord::Base
  belongs_to :working_group
  has_many :tasks

  has_many :messages, class_name: '::DiscussionMessage'

  has_many :discussion_watchings, class_name: '::DiscussionWatcher'
  has_many :watchers, through: :discussion_watchings, class_name: 'Volunteer'
end
