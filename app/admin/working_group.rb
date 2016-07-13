ActiveAdmin.register WorkingGroup do

  index do
    selectable_column
    column :name
    column :circle
    column :is_private
    column :status
    column :created_at
    column :updated_at
    actions
  end

end
