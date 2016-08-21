ActiveAdmin.register Task do

  index do
    selectable_column
    column :id
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
    column :volunteers do |taskable|
      taskable.volunteers.count
    end
    column :project
    column :created_at
    column :updated_at
    column :completed_at
    actions
  end

end