require 'rails_helper'

describe Task do
  it { is_expected.to have_many(:volunteers).class_name(User) }
  it { is_expected.to have_many(:organizers).class_name(User) }
  it { is_expected.to belong_to(:working_group).class_name(WorkingGroup) }
  it { is_expected.to validate_presence_of(:working_group) }
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:due_date) }
  it { is_expected.to validate_presence_of(:description) }
end