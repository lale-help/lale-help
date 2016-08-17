FactoryGirl.define do
  factory :working_group, aliases: [:public_working_group] do
    sequence(:name) {|n| "Group #{n}" }
    circle

    transient do
      admin nil
      admins []
      member nil
      members []
    end

    after(:create) do |wg, evaluator|
      # assign admins
      Array(evaluator.admin || evaluator.admins).each do |user|
        create(:working_group_admin_role, working_group: wg, user: user)
        # a user needs an (active!) circle role in order to be fully functional in the app.
        unless evaluator.circle.roles.exists?(user: user)
          create(:circle_role_volunteer, circle: evaluator.circle, user: user)
        end
      end
      # assign members
      Array(evaluator.member || evaluator.members).each do |user|
        create(:working_group_member_role, working_group: wg, user: user)
        # a user needs an (active!) circle role in order to be fully functional in the app.
        unless evaluator.circle.roles.exists?(user: user)
          create(:circle_role_volunteer, circle: evaluator.circle, user: user)
        end
      end
    end

    factory :private_working_group do
      is_private true
    end

  end

  factory :working_group_admin_role, aliases: [:working_group_organizer_role], class: WorkingGroup::Role do
    role_type { "admin" }
    user
    working_group
  end

  factory :working_group_member_role, aliases: [:working_group_volunteer_role], class: WorkingGroup::Role do
    role_type { "member" }
    user
    working_group
  end

end
