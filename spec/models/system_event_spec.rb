require 'rails_helper'

describe SystemEvent do
  it { should have_many(:notifications).class_name(SystemEvent::Notification) }
  it { should belong_to(:volunteer).class_name(Volunteer) }
  it { should belong_to(:for) }
end