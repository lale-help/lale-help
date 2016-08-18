FactoryGirl.define do
  
  factory :supply_role, class: Supply::Role do

    user
    supply

    factory :supply_organizer_role, aliases: [:supply_admin_role] do
      role_type "supply.organizer"
    end

    factory :supply_volunteer_role, aliases: [:supply_member_role, :supply_assignee_role] do
      role_type "supply.volunteer"
    end
  end
end
