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

    transient do
      admin nil
      admins []
      volunteer nil
      volunteers []
    end

    after(:create) do |circle, evaluator|
      # assign admins
      if (evaluator.admin || evaluator.admins.present?)
        Array(evaluator.admin || evaluator.admins).each do |user|
          create(:circle_role_admin, circle: circle, user: user)
        end
      end
      # assign volunteers
      if (evaluator.volunteer || evaluator.volunteers.present?)
        Array(evaluator.volunteer || evaluator.volunteers).each do |user|
          create(:circle_role_volunteer, circle: circle, user: user)
        end
      end
    end

    trait :with_admin do
      after(:create) do |circle, evaluator|
        create(:circle_role_admin, circle: circle, user: create(:user))
      end
    end

    trait :with_volunteer do
      after(:create) do |circle, evaluator|
        create(:circle_role_volunteer, circle: circle, user: create(:user))
      end
    end

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
