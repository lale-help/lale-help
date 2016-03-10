FactoryGirl.define do

  factory :user, aliases: [:admin, :volunteer] do
    sequence(:first_name) {|n| "John#{n}" }
    sequence(:last_name)  {|n| "Doe#{n}" }
    address { create(:user_address) }
    after(:create) do |user, _|
      user.active!
      create(:user_identity, user: user)
    end

    factory :pending_user do
      after(:create) do |user, _|
        user.pending!
      end
    end
  end

  factory :user_identity, class: User::Identity, aliases: [:volunteer_identity] do
    email    { "#{user.first_name}#{user.id}@example.com" }
    password { SecureRandom.hex(5) }
  end
end
