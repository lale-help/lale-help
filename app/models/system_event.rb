class SystemEvent < ActiveRecord::Base
  belongs_to :volunteer, inverse_of: :triggered_system_events
  has_many :notifications

  belongs_to :for, polymorphic: true
end
