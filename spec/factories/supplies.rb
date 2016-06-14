FactoryGirl.define do
  factory :supply do
    working_group
    sequence(:name) {|n| "Supply #{n}" }
    sequence(:description) {|n| "Description #{n}" }
    due_date { Faker::Date.forward(20) }
    location
  end
end
