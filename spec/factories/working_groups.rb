FactoryGirl.define do
  factory :working_group do
    sequence(:name) {|n| "Group #{n}" }
    circle

    factory :private_working_group do
      is_private true
    end
  end

  factory :working_group_admin_role, class: WorkingGroup::Role do
    role_type { "admin" }
    user
    working_group
  end

  factory :working_group_member_role, class: WorkingGroup::Role do
    role_type { "member" }
    user
    working_group
  end

end
