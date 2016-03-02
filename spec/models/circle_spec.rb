require 'rails_helper'

describe Circle do
  it { should have_many(:users).class_name(User) }
  it { should have_many(:admins).class_name(User) }
  it { should have_many(:volunteers).class_name(User) }
  it { should have_many(:officials).class_name(User) }
  it { should have_many(:leadership).class_name(User) }
  it { should have_many(:tasks).class_name(Task) }
  it { should belong_to(:address).class_name(Address) }
end