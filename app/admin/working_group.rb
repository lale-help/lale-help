ActiveAdmin.register WorkingGroup do

  index do
    selectable_column
    column :id
    column :name
    column :circle
    column :is_private
    column :status
    column :organizers_count do |wg|
        wg.admins.count
    end
    column :members_count do |wg|
        wg.members.count
    end
    column :created_at
    column :updated_at
    actions
  end

end
