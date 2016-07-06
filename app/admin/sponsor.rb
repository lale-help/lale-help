ActiveAdmin.register Sponsor do

  index do
    selectable_column
    column :name
    column :url
    column :current_sponsorships do |sponsor|
      sponsor.sponsorships.current.count
    end
    column :created_at
    column :updated_at
    actions
  end

  sidebar "Current Sponsorships", only: [:edit, :show] do
    ul do
      sponsorships = sponsor.sponsorships.current.order(ends_on: :asc)
      sponsorships.each do |s|
        circle_link = link_to(s.circle.name, admin_circle_path(s.circle))
        li "#{circle_link} from #{s.starts_on} to #{s.ends_on}.".html_safe
      end
    end
  end

end
