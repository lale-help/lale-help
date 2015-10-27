FactoryGirl.define do
  factory :volunteer, aliases: [:admin] do
    sequence(:first_name) {|n| "John#{n}" }
    sequence(:last_name)  {|n| "Doe#{n}" }
    after(:create) do |volunteer, _|
      create(:volunteer_identity, volunteer: volunteer)
    end
  end

  factory :volunteer_identity, class: Volunteer::Identity do
    email Faker::Internet.email
    password { SecureRandom.hex(5) }
  end
end
