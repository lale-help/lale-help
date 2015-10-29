require 'rails_helper'

describe Circle do
  it { should have_many(:members).class_name(User) }
  it { should have_many(:tasks).class_name(Task) }
  it { should belong_to(:location).class_name(Location) }
end