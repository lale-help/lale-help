FactoryGirl.define do
  
  factory :task_role, class: Task::Role do

    user
    task

    factory :task_organizer_role, aliases: [:task_admin_role] do
      role_type "task.organizer"
    end

    factory :task_volunteer_role, aliases: [:task_member_role, :task_assignee_role] do
      role_type "task.volunteer"
    end
  end
end
