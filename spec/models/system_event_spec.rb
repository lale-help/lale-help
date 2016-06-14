require 'rails_helper'

describe SystemEvent do
  it { is_expected.to have_many(:notifications).class_name(SystemEvent::Notification) }
  it { is_expected.to belong_to(:user).class_name(User) }
  it { is_expected.to belong_to(:for) }
end