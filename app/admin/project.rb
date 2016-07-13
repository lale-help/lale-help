ActiveAdmin.register Project do

  index do
    selectable_column
    column :name
    column :circle do |project|
      begin
        c = project.working_group.circle
        link_to(c.name, admin_circle_path(c))
      rescue
        "No circle!"
      end
    end
    column :working_group
    column :created_at
    column :updated_at
    actions
  end


end
