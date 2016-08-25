FactoryGirl.define do

  factory :task do

    working_group
    sequence(:name) {|n| "Task #{n}" }
    sequence(:description) {|n| "Description #{n}" }
    due_date { Faker::Date.forward(20) }
    volunteer_count_required 1

    #
    # use it like this to create a task with an organizer: 
    # create(:task, organizer: a_user_instance)
    # 
    transient do
      organizer nil
      volunteer nil
      volunteers []
    end

    # using the transient attribute to assign an organizer
    after(:create) do |task, evaluator|
      if evaluator.organizer
        create(:task_organizer_role, user: evaluator.organizer, task: task)
      end
      # assign volunteers
      Array(evaluator.volunteer || evaluator.volunteers).each do |user|
        create(:task_volunteer_role, user: user, task: task)
      end

    end

    # a task with all attributes set / set to non-default values
    trait :nondefault do
      # some of these only work with attributes_for since the values are not valid for a model,
      # but required as they are for the form
      due "between"
      due_date { Date.parse("2030-01-31") }
      due_time "14:00"
      duration "All day"
      location "Munich"
      start_date { Date.parse("2030-01-30") }
      start_time "12:00"
      volunteer_count_required 3
    end

    trait :with_location do
      after(:create) do |task, _|
        task.location_assignments.create(primary: true, location: create(:location))
      end
    end

    trait :with_admin do
      after(:create) do |task, evaluator|
        create(:task_admin_role, task: task, user: create(:user))
      end
    end

    trait :with_volunteer do
      after(:create) do |task, evaluator|
        create(:task_volunteer_role, task: task, user: create(:user))
      end
    end

    trait :with_volunteers do
      after(:create) do |task, evaluator|
        create(:task_volunteer_role, task: task, user: create(:user))
        create(:task_volunteer_role, task: task, user: create(:user))
      end
    end

    trait :completed do
      completed_at { Date.today }
    end

  end
end
