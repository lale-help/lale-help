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
    column "Active admins" do |circle|
      circle.admins.active.count
    end
    column "Current sponsorships" do |circle|
      circle.sponsorships.current.count
    end

    actions
  end

  # FIXME DRY this up when improving the admin
  sidebar "Current Sponsorships", only: [:edit, :show] do
    sponsorships = Sponsorship.current.where(circle: circle).order(ends_on: :asc)
    if sponsorships.empty?
      i "This circle has no current sponsorships."
    else
      ul do
        sponsorships.each do |s|
          sponsor_link = link_to(s.sponsor.name, admin_sponsor_path(s.sponsor))
          li "#{sponsor_link} from #{s.starts_on} to #{s.ends_on}.".html_safe
        end
      end
    end
  end

  # FIXME DRY this up when improving the admin
  sidebar "Active Admins", only: [:edit, :show] do
    users = circle.admins.active.order(:first_name)
    if users.empty?
      i "This circle has no active admins."
    else
      ul do
        users.each do |user|
          li link_to(user.name, admin_user_path(user))
        end
      end
    end
  end

  # FIXME DRY this up when improving the admin
  sidebar "Active Helpers", only: [:edit, :show] do
    users = circle.users.active.order(:first_name)
    if users.empty?
      i "This circle has no active users."
    else
      ul do
        users.each do |user|
          li link_to(user.name, admin_user_path(user))
        end
      end
    end
  end

end
