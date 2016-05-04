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

  factory :circle_role, class: Circle::Role do
    
    user
    circle
    status { :active }

    after(:create) do |role, evaluator|
      role.user.update_attribute(:primary_circle, role.circle)
    end

    factory :circle_role_volunteer do
      role_type { "circle.volunteer" }
    end

    factory :circle_role_admin do
      role_type { "circle.admin" }
    end
  end
end
