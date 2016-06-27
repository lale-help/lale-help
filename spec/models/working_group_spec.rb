require 'rails_helper'

describe WorkingGroup do
  it { is_expected.to have_many(:tasks).class_name(Task) }
  it { is_expected.to belong_to(:circle).class_name(Circle) }
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:circle) }
end