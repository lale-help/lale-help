require 'rails_helper'

describe SystemEvent do
  it { should have_many(:notifications).class_name(SystemEvent::Notification) }
  it { should belong_to(:user).class_name(User) }
  it { should belong_to(:for) }
end