ActiveAdmin.register Sponsorship do

  index do
    selectable_column
    column :sponsor
    column :circle
    column :starts_on
    column :ends_on
    column :created_at
    column :updated_at
    actions
  end

end
