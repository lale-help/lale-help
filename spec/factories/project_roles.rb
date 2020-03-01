FactoryGirl.define do

  factory :project_admin_role, class: Project::Role do
    user
    project
    role_type :admin
  end

end
