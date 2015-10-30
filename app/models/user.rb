class User < ActiveRecord::Base
  has_many :feedback

  has_many :triggered_system_events, class_name: '::SystemEvent'
  has_many :notifications, class_name: '::SystemEvent::Notification'

  has_one :identity

  belongs_to :location
  belongs_to :circle

  has_many :task_roles, class_name: 'Task::Role'
  has_many :tasks, ->{ distinct }, through: :task_roles

  has_many :circle_roles, class_name: 'Circle::Role'
  has_many :circles, ->{ distinct }, through: :circle_roles

  has_many :working_group_roles, class_name: 'WorkingGroup::Role'
  has_many :working_groups, ->{ distinct }, through: :working_group_roles

  def name
    "#{first_name} #{last_name}"
  end

  def email
    identities.present? && identities.first.email
  end

  def tasks_for_circle circle
    task_assignments.where(circle: circle).tasks
  end
end
