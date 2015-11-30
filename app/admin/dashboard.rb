ActiveAdmin.register_page "Dashboard" do

  menu priority: 1, label: proc{ I18n.t("active_admin.dashboard") }

  content do
    columns do
        column do
            panel "Circles" do
                Circle.order("updated_at DESC").last(5).each do |circle|
                    div do

                    end
                end
            end
        end
        column do
            panel "Users" do
                div p "Total No.: #{User.count}"
                div p "Average User in Circle: TODO"
                div p "Average Workgroup in Circle: TODO"
            end
        end
        column do
            panel "Statistics" do
                div p "Number of Tasks: #{Task.count}"

                div p "Number of Circles: #{Circle.count}"

                div p "Number of Workgroups: #{WorkingGroup.count}"
            end
        end
    end
  end
end
