require 'rails_helper'

describe WorkingGroup do
  it { should have_many(:volunteers).class_name(::Volunteer) }
  it { should have_many(:tasks).class_name(Task) }
  it { should belong_to(:circle).class_name(Circle) }
end