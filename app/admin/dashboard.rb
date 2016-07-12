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
                div "Total No.: #{User.count}"
            end
        end
        column do
            panel "Statistics" do
                div "Number of Tasks: #{Task.count}"

                div "Number of Circles: #{Circle.count}"

                div "Number of Workgroups: #{WorkingGroup.count}"
            end
        end
    end
  end
end
