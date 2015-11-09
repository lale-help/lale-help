FactoryGirl.define do
  factory :circle do
    sequence(:name) {|n| "Circle #{n}" }
    location_text { "San Francisco, CA" }
    location
  end

  factory :circle_role, class: Circle::Role do
    role_type { "circle.volunteer" }
    user
    circle
  end
end
