describe Circle::CreateCircle do
  subject { Circle::CreateCircle }
  let(:volunteer)     { create(:volunteer) }
  let(:location_name) { 'Munich, Germany' }

  it 'creates a circle for a location name' do
    outcome = subject.run(location_name: location_name, user: volunteer, name: 'My Awesome Circle')
    expect(outcome.result).to be_a(Circle)
    expect(outcome.result).to be_persisted
    expect(SystemEvent.find_by(volunteer: volunteer, for: outcome.result)).to be_present
  end
end