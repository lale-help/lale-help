class SystemEvent::Notification::Delivery < ActiveRecord::Base
  belongs_to :notification

  enum method: { email: 0, sms: 1 }
end
