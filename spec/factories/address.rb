FactoryGirl.define do
  factory :user_address, class: Address do
    city           "San Francisco"
    state_province "CA"
    postal_code    "94109"
    country        "USA"
  end
end
