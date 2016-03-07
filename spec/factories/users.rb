FactoryGirl.define do
  factory :user, aliases: [:admin, :volunteer] do
    sequence(:first_name) {|n| "John#{n}" }
    sequence(:last_name)  {|n| "Doe#{n}" }
    after(:create) do |user, _|
      user.active!
      create(:user_identity, user: user)
    end
  end

  factory :user_identity, class: User::Identity, aliases: [:volunteer_identity] do
    email    { "#{user.first_name}#{user.id}@example.com" }
    password { SecureRandom.hex(5) }
  end
end
