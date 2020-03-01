FactoryGirl.define do
  factory :supply do
    working_group
    sequence(:name) {|n| "Supply #{n}" }
    sequence(:description) {|n| "Description #{n}" }
    due_date { Faker::Date.forward(20) }
    location

    #
    # use it like this to create a supply with an organizer:
    # create(:supply, organizer: a_user_instance)
    #
    transient do
      organizer nil
      volunteer nil
      volunteers []
    end

    # using the transient attribute to assign an organizer
    after(:create) do |supply, evaluator|
      organizer = if evaluator.organizer
        evaluator.organizer
      else
        # when no organizer is given, create one that is valid (in working group and circle)
        create(:working_group_member_role, working_group: evaluator.working_group).user
      end
      create(:supply_organizer_role, user: organizer, supply: supply)
      if evaluator.volunteer
        create(:supply_volunteer_role, user: evaluator.volunteer, supply: supply)
      end
    end

    trait :with_admin do
      after(:create) do |supply, evaluator|
        create(:supply_admin_role, supply: supply, user: create(:user))
      end
    end

    trait :with_volunteer do
      after(:create) do |supply, evaluator|
        create(:supply_volunteer_role, supply: supply, user: create(:user))
      end
    end

    trait :completed do
      completed_at { Date.today }
    end

  end
end
