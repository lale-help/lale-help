FactoryGirl.define do

  factory :user, aliases: [:admin, :volunteer] do
    sequence(:first_name) {|n| "John#{n}" }
    sequence(:last_name)  {|n| "Doe#{n}" }
    address { create(:user_address) }
    after(:create) do |user, _|
      # FIXME "active" has no meaning without a circle now.
      # user.active!
      create(:user_identity, user: user)
    end

    factory :working_group_admin do
      after(:create) do |user, _|
        create(:working_group_admin_role, user: user)
      end
    end

    factory :working_group_member do
      after(:create) do |user, _|
        create(:working_group_member_role, user: user)
      end
    end

    factory :circle_admin do
      after(:create) do |user, _|
        create(:circle_role_admin, user: user)
      end
    end

    factory :circle_volunteer do
      after(:create) do |user, _|
        create(:circle_role_volunteer, user: user)
      end
    end

  end

  factory :user_identity, class: User::Identity, aliases: [:volunteer_identity] do
    email    { "#{user.first_name}#{user.id}@example.com" }
    password { SecureRandom.hex(5) }
  end
end
