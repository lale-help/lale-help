ActiveAdmin.register Supply do

  index do
    selectable_column
    column :name
    column :working_group
    column :circle do |taskable|
      begin
        c = taskable.working_group.circle
        link_to(c.name, admin_circle_path(c))
      rescue
        "No circle!"
      end
    end
    column :project
    column :completed_at
    column :created_at
    column :updated_at
    actions
  end

end