FactoryGirl.define do
  factory :project do
    sequence(:name) {|n| "Group #{n}" }
    working_group
  end

  factory :project_admin_role, class: Project::Role do    
    user
    project
    role_type :admin
  end

end
