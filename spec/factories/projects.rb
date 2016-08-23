FactoryGirl.define do

  factory :project do
    
    sequence(:name) {|n| "Project #{n}" }
    sequence(:description) {|n| "Decription of project #{n}" }
    working_group

    transient do
      admin nil
      admins []
    end

    after(:create) do |project, evaluator|
      # assign admin(s)
      Array(evaluator.admin || evaluator.admins).each do |user|
        create(:project_admin_role, project: project, user: user)
      end
    end

    trait :with_admin do
      after(:create) do |project, evaluator|
        create(:project_admin_role, project: project, user: create(:user))
      end
    end

  end

  factory :project_admin_role, class: Project::Role do    
    user
    project
    role_type :admin
  end

end
