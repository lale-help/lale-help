FactoryGirl.define do

  factory :working_group_role, class: WorkingGroup::Role do
    user
    working_group
    
    factory :working_group_admin_role, aliases: [:working_group_organizer_role] do
      role_type { "admin" }
    end

    factory :working_group_member_role, aliases: [:working_group_volunteer_role] do
      role_type { "member" }
    end

  end  
end
