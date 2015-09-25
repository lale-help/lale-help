FactoryGirl.define do
  factory :task do
    working_group
    sequence(:name) {|n| "Task #{n}" }
    sequence(:description) {|n| "Description #{n}" }
    due_date { Faker::Date.forward(20) }
  end
end
