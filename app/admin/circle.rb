ActiveAdmin.register Circle do

  index do
    selectable_column
    column :name
    column "City, Country" do |circle|
      s = []
      s << circle.address.city if circle.address.city 
      s << circle.address.country if circle.address.country 
      s.join(', ')
    end
    column "Active helpers" do |circle|
      circle.users.active.count
    end
    column "Active sdmins" do |circle|
      circle.admins.active.count
    end
    column "Current sponsorships" do |circle|
      circle.sponsorships.current.count
    end

    actions
  end

  sidebar "Current Sponsorships", only: [:edit, :show] do
    ul do
      sponsorships = Sponsorship.current.where(circle: circle).order(ends_on: :asc)
      sponsorships.each do |s|
        sponsor_link = link_to(s.sponsor.name, admin_sponsor_path(s.sponsor))
        li "#{sponsor_link} from #{s.starts_on} to #{s.ends_on}.".html_safe
      end
    end
  end

  sidebar "Active Helpers", only: [:edit, :show] do
    ul do
      circle.users.active.each do |user|
        li user.name
      end
    end
  end

end
