ActiveAdmin.register_page "Dashboard" do

  menu priority: 1, label: proc{ I18n.t("active_admin.dashboard") }

  content do
    columns do
      column do
        panel "Newest circles" do
          Circle.order(created_at: :desc).last(10).each do |circle|
            ul do
              text = "#{circle.name} (created #{distance_of_time_in_words_to_now(circle.created_at)} ago)"
              li link_to(text, admin_circle_path(circle))
            end
          end
        end
      end
      column do
        panel "Statistics" do
          div "Number of Tasks: #{Task.count}"
          div "Number of Circles: #{Circle.count}"
          div "Number of Workgroups: #{WorkingGroup.count}"
          div "Number of Users: #{User.count}"
          div "Number of Files: #{FileUpload.count}"
        end
      end
    end
  end
end
