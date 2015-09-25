require 'rails_helper'

describe Circle do
  it { should have_many(:volunteers).class_name(Volunteer) }
  it { should have_many(:tasks).class_name(Task) }
  it { should belong_to(:location).class_name(Location) }
end