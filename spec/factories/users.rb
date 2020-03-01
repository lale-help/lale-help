FactoryGirl.define do

  factory :user, aliases: [:admin, :volunteer] do
    sequence(:first_name) {|n| "John#{n}" }
    sequence(:last_name)  {|n| "Doe#{n}" }
    address { create(:user_address) }
    after(:create) do |user, _|
      create(:user_identity, user: user)
    end
    is_admin false

    trait :with_profile_image do
      profile_image { File.open('spec/fixtures/images/avatar.jpg') }
    end

    trait :working_group_admin do
      after(:create) do |user, _|
        create(:working_group_admin_role, user: user)
      end
    end

    trait :working_group_member do
      after(:create) do |user, _|
        create(:working_group_member_role, user: user)
      end
    end

    trait :circle_admin do
      after(:create) do |user, _|
        create(:circle_role_admin, user: user)
      end
    end

    trait :circle_volunteer do
      after(:create) do |user, _|
        create(:circle_role_volunteer, user: user)
      end
    end

  end

end
