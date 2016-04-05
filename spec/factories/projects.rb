FactoryGirl.define do
  factory :project do
    sequence(:name) {|n| "Group #{n}" }
    working_group
  end
end
