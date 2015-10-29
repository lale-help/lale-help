class User < ActiveRecord::Base
  has_many :feedback

  has_many :triggered_system_events, class_name: '::SystemEvent'
  has_many :notifications, class_name: '::SystemEvent::Notification'

  has_many :identities

  belongs_to :location
  belongs_to :circle

  def name
    "#{first_name} #{last_name}"
  end

  def email
    identities.present? && identities.first.email
  end
end
