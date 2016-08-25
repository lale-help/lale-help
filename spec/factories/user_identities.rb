FactoryGirl.define do

  factory :user_identity, class: User::Identity, aliases: [:volunteer_identity] do
    email    { "#{user.first_name}#{user.id}@example.com" }
    password { SecureRandom.hex(5) }
  end
end
