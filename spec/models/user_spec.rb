require 'rails_helper'

describe User do
  it { should have_many(:triggered_system_events).class_name(SystemEvent) }
  it { should have_many(:notifications).class_name(SystemEvent::Notification) }
end