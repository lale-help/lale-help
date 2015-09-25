FactoryGirl.define do
  factory :circle do
    sequence(:name) {|n| "Circle #{n}" }
    location
    admin
  end
end
