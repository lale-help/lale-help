class SystemEvent < ActiveRecord::Base
  belongs_to :user, inverse_of: :triggered_system_events
  has_many :notifications

  belongs_to :for, polymorphic: true

  enum action: { created: 0, updated: 1, removed: 2, completed: 3 }
end
