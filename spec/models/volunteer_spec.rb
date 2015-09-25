require 'rails_helper'

describe Volunteer do
  it { should have_many(:tasks).class_name(Task) }

  it { should have_many(:triggered_system_events).class_name(SystemEvent) }
  it { should have_many(:notifications).class_name(SystemEvent::Notification) }

  it { should have_many(:feedback).class_name(::Volunteer::Feedback) }
end