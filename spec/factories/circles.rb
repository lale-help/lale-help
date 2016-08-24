FactoryGirl.define do

  factory :circle_create_form, class: Circle::CreateForm do
    sequence(:name)  {|n| "Circle #{n}" }
    sequence(:description) {|n| "Description of circle #{n}" }
    city             { "San Francisco" }
    state_providence { "California" }
    country          { "Canada" }
    postal_code      { "94109" }
    user             { create(:user) }
  end

  factory :empty_required_circle_attributes, class: Circle::CreateForm do
    name             ""
    city             ""
    postal_code      ""
    country          "Select Country"
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
      Array(evaluator.admin || evaluator.admins).each do |user|
        create(:circle_role_admin, circle: circle, user: user)
      end
      # assign volunteers
      Array(evaluator.volunteer || evaluator.volunteers).each do |user|
        create(:circle_role_volunteer, circle: circle, user: user)
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

    trait :with_admin_and_working_group do
      with_admin
      after(:create) do |circle, evaluator|
        create(:working_group, circle: circle, member: circle.admin)
      end
    end

    trait :with_admin_volunteer_and_working_group do
      with_admin
      with_volunteer
      after(:create) do |circle, evaluator|
        create(:working_group, circle: circle, members: [circle.admin, circle.volunteer])
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

    factory :circle_role_volunteer, aliases: [:circle_member_role] do
      role_type { "circle.volunteer" }
    end

    factory :circle_role_admin, aliases: [:circle_admin_role] do
      role_type { "circle.admin" }
    end
  end
end
