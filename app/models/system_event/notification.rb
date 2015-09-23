class SystemEvent::Notification < ActiveRecord::Base
  belongs_to :system_event
  belongs_to :volunteer
  has_many :deliveries
end
