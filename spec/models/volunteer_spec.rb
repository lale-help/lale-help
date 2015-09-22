require 'rails_helper'

describe Volunteer do
  it { should have_many(:tasks).class_name(Task) }

  it { should have_many(:working_groups).class_name(WorkingGroup) }

  it { should have_many(:triggered_system_events).class_name(SystemEvent) }
  it { should have_many(:notifications).class_name(SystemEventNotification) }

  it { should have_many(:watched_discussions).class_name(Discussion) }
  it { should have_many(:discussion_messages).class_name(DiscussionMessage) }

  it { should have_many(:feedback).class_name(VolunteerFeedback) }
end