FactoryGirl.define do

  factory :working_group_role, class: WorkingGroup::Role do
    user
    working_group

    # an active circle volunteer role is required for a lale user to work correctly.
    # there's no case where a user is in a working group admin without being circle volunteer as well.
    after(:create) do |role, evaluator|
      circle = evaluator.working_group.circle
      unless circle.roles.volunteer.exists?(user: evaluator.user)
        create(:circle_role_volunteer, circle: circle, user: evaluator.user)
      end
    end
    
    factory :working_group_admin_role, aliases: [:working_group_organizer_role] do
      role_type { "admin" }
    end

    factory :working_group_member_role, aliases: [:working_group_volunteer_role] do
      role_type { "member" }
    end

  end  
end
