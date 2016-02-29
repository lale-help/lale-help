FactoryGirl.define do

  factory :circle_create_form, class: Circle::Create do
    sequence(:name) {|n| "Circle #{n}" }
    location        {    "San Francisco, CA" }
    user            { create :user }
  end

  factory :circle do
    sequence(:name) {|n| "Circle #{n}" }
    location_text { "San Francisco, CA" }
    location
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
