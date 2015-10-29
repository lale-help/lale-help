describe Task::VolunteerAssignment do
  it { should belong_to(:user) }
  it { should belong_to(:task) }
  it { expect(create(:task_volunteer_assignment)).to validate_uniqueness_of(:user).scoped_to(:task_id) }
end