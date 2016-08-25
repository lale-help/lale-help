FactoryGirl.define do

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