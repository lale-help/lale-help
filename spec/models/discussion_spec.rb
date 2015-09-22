require 'rails_helper'

describe Discussion do
  it { should have_many(:watchers).class_name(Volunteer) }
  it { should have_many(:tasks).class_name(Task) }
  it { should have_many(:messages).class_name(DiscussionMessage) }
  it { should belong_to(:working_group).class_name(WorkingGroup) }
end