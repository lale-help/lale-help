require 'rails_helper'

describe DiscussionMessage do
  it { should belong_to(:discussion).class_name(Discussion) }
  it { should belong_to(:volunteer).class_name(Volunteer) }
end