FactoryGirl.define do

  factory :task do

    working_group
    sequence(:name) {|n| "Task #{n}" }
    sequence(:description) {|n| "Description #{n}" }
    due_date { Faker::Date.forward(20) }
    volunteer_count_required 1

    #
    # use it like this to create a task with an organizer: 
    # create(:task_with_organizer, organizer: a_user_instance)
    # 
    transient do
      organizer nil
    end

    # using the transient attribute to assign an organizer
    after(:create) do |task, evaluator|
      if evaluator.organizer
        create(:task_organizer_role, user: evaluator.organizer, task: task)
      end
    end

    factory :urgent_task do
      due_date { Date.today + 1.day }
    end

    factory :task_with_location do
      after(:create) do |task, _|
        location = create(:location)
        task.location_assignments.create(primary: true, location: location)
      end
    end

    # a task with all attributes set / set to non-default values
    factory :full_task do
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
  end
end
