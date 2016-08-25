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

    trait :with_admin do
      after(:create) do |wg, evaluator|
        user = create(:user)
        create(:working_group_admin_role, working_group: wg, user: user)
        # an active role on circle is required for the new user to be considered an active admin
        create(:circle_member_role, circle: wg.circle, user: user)
      end
    end

    trait :with_members do
      after(:create) do |wg, evaluator|
        create(:working_group_volunteer_role, working_group: wg, user: create(:user))
        create(:working_group_volunteer_role, working_group: wg, user: create(:user))
      end
    end

    trait :private do
      is_private true
    end

  end

end
