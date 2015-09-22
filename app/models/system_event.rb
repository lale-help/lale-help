class SystemEvent < ActiveRecord::Base
  belongs_to :volunteer, inverse_of: :triggered_system_events
  has_many :notifications, class_name: '::SystemEventNotification'

  belongs_to :for, polymorphic: true
end
