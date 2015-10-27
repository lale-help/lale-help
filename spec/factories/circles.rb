FactoryGirl.define do
  factory :circle do
    sequence(:name) {|n| "Circle #{n}" }
    location_text { "San Francisco, CA" }
    location
    admin
    after(:create) { |circle, evaluator|
      circle.admin.circle = circle
      circle.admin.save
    }
  end
end
