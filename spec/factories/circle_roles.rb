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

      # an active circle volunteer role is required for a lale user to work correctly.
      # there's no case where a user is circle admin without being volunteer as well.
      after(:create) do |role, evaluator|
        unless evaluator.circle.roles.exists?(user: evaluator.user, role_type: 'circle.volunteer')
          create(:circle_role_volunteer, circle: evaluator.circle, user: evaluator.user)
        end
      end
    end
  end
  
end