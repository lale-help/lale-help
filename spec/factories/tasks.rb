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
  end
end
