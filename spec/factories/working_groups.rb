FactoryGirl.define do
  factory :working_group do
    sequence(:name) {|n| "Group #{n}" }
    circle
  end
end
