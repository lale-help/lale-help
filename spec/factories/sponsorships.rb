FactoryGirl.define do

  factory :sponsorship do

    circle
    sponsor
    starts_on { Date.today }
    ends_on { Date.today }

    trait :current do
      starts_on { Date.today - 6.months}
      ends_on { Date.today + 6.months}
    end

    trait :past do
      starts_on { Date.today - 2.years }
      ends_on { Date.today - 1.years }
    end

    trait :future do
      starts_on { Date.today + 1.years }
      ends_on { Date.today + 2.years }
    end

  end
end
