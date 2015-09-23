FactoryGirl.define do
  factory :volunteer do
    first_name "John"
    last_name  "Doe"
    email      Faker::Internet.email
  end
end
