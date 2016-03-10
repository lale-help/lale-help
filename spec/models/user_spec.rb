require 'rails_helper'

describe User do
  it { should have_many(:triggered_system_events).class_name(SystemEvent) }
  it { should have_many(:notifications).class_name(SystemEvent::Notification) }
  it { should respond_to(:language) }
  it "should default to language :en" do
    expect(subject.language).to eq("en")
  end
  it { should respond_to(:status) }
  it "should default to status nil" do
    expect(subject.status).to be_nil
  end
end