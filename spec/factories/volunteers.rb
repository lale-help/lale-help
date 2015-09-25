FactoryGirl.define do
  factory :volunteer, aliases: [:admin] do
    sequence(:first_name) {|n| "John#{n}" }
    sequence(:last_name)  {|n| "Doe#{n}" }
    email      Faker::Internet.email
  end
end
