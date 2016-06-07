FactoryGirl.define do
  factory :task do

    working_group
    sequence(:name) {|n| "Task #{n}" }
    sequence(:description) {|n| "Description #{n}" }
    due_date { Faker::Date.forward(20) }

    factory :task_with_location do
      after(:create) do |task, _|
        location = create(:location)
        task.location_assignments.create(primary: true, location: location)
      end
    end
  end
end
