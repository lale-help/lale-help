require 'rails_helper'

describe "Show lale admin dashboard", js: true do

  let(:circle)       { create(:circle, :with_admin) }
  let(:current_user) { circle.admin }

  let(:admin_dashboard_page) { PageObject::LaleAdmin::Dashboard.new }

  context "current user is lale admin" do

    before { current_user.update_attributes(is_admin: true) }
    before { admin_dashboard_page.load(as: current_user.id) }

    it "shows the admin dashboard" do
      expect(admin_dashboard_page.headline.text).to eq("Dashboard")
      expect(admin_dashboard_page).to have_circles_admin_link
    end

  end

  context "current user is no lale admin" do

    before { current_user.update_attributes(is_admin: false) }
    before { admin_dashboard_page.load(as: current_user.id) }

    let(:circle_dashboard_page) { PageObject::Circle::Dashboard.new }

    it "shows the user's circle dashboard" do
      expect(circle_dashboard_page.headline.text).to eq("Dashboard for #{circle.name}")
      expect(circle_dashboard_page).to have_add_menu
    end

  end

  context "no user signed in" do

    before { admin_dashboard_page.load }

    let(:sign_in_page) { PageObject::SignIn::Form.new }

    it "redirects to sign in" do
      expect(sign_in_page.headline.text).to eq('Sign in to your circle')
    end
  end

end