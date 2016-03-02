FactoryGirl.define do

  factory :circle_create_form, class: Circle::CreateForm do
    sequence(:name)  {|n| "Circle #{n}" }
    city             { "San Francisco" }
    state_providence { "California" }
    country          { "US" }
    postal_code      { "94109" }
    user             { create :user }
  end

  factory :circle do
    sequence(:name) {|n| "Circle #{n}" }
  end

  factory :circle_role_volunteer, class: Circle::Role do
    role_type { "circle.volunteer" }
    user
    circle
  end

  factory :circle_role_admin, class: Circle::Role do
    role_type { "circle.admin" }
    user
    circle
  end
end
