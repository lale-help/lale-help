FactoryGirl.define do

  factory :project do
    
    sequence(:name) {|n| "Project #{n}" }
    sequence(:description) {|n| "Decription of project #{n}" }
    working_group

    transient do
      admin nil
      admins []
      task nil
      tasks []
    end

    after(:create) do |project, evaluator|
      # assign admin(s)
      Array(evaluator.admin || evaluator.admins).each do |user|
        create(:project_admin_role, project: project, user: user)
      end
      Array(evaluator.task || evaluator.tasks).each do |user|
        evaluator.tasks.each do |task|
          task.update_attributes(working_group: project.working_group, project: project)
        end
      end
    end

    trait :with_admin do
      after(:create) do |project, evaluator|
        create(:project_admin_role, project: project, user: create(:user))
      end
    end

    trait :open do
      completed_at nil
    end

    trait :completed do
      completed_at Time.now
    end

  end

end
