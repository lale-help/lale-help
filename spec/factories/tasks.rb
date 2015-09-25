FactoryGirl.define do
  factory :task do
    working_group
    sequence(:name) {|n| "Task #{n}" }
    sequence(:description) {|n| "Description #{n}" }
  end
end
