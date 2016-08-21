FactoryGirl.define do

  factory :sponsor do
    name { Faker::Company.name }
    url { Faker::Internet.url }
  end
end
