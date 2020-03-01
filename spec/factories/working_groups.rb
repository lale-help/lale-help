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
        # an active circle role is required for a lale user to work correctly.
        unless evaluator.circle.roles.volunteer.exists?(user: user)
          create(:circle_role_volunteer, circle: evaluator.circle, user: user)
        end
      end
      # assign members
      Array(evaluator.member || evaluator.members).each do |user|
        create(:working_group_member_role, working_group: wg, user: user)
        # an active circle role is required for a lale user to work correctly.
        unless evaluator.circle.roles.volunteer.exists?(user: user)
          create(:circle_role_volunteer, circle: evaluator.circle, user: user)
        end
      end
    end

    trait :with_admin do
      after(:create) do |wg, evaluator|
        member = create(:user)
        create(:working_group_admin_role, working_group: wg, user: member)
        # an active circle role is required for a lale user to work correctly.
        unless evaluator.circle.roles.volunteer.exists?(user: member)
          create(:circle_role_volunteer, circle: wg.circle, user: member)
        end
      end
    end

    trait :with_members do
      after(:create) do |wg, evaluator|
        2.times do
          member = create(:user)
          create(:working_group_volunteer_role, working_group: wg, user: member)
          # an active circle role is required for a lale user to work correctly.
          unless evaluator.circle.roles.volunteer.exists?(user: member)
            create(:circle_role_volunteer, circle: wg.circle, user: member)
          end
        end
      end
    end

    trait :private do
      is_private true
    end

  end

end
