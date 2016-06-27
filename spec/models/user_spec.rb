require 'rails_helper'

describe User do
  it { is_expected.to have_many(:triggered_system_events).class_name(SystemEvent) }
  it { is_expected.to have_many(:notifications).class_name(SystemEvent::Notification) }
  it { is_expected.to respond_to(:language) }
  it "should default to language :en" do
    expect(subject.language).to eq("en")
  end
end