require 'rails_helper'

describe WorkingGroup do
  it { should have_many(:tasks).class_name(Task) }
  it { should belong_to(:circle).class_name(Circle) }
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:circle) }
end