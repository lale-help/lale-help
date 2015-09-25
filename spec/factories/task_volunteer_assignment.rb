FactoryGirl.define do
  factory :task_volunteer_assignment, class: Task::VolunteerAssignment do
    task
    volunteer
  end
end
