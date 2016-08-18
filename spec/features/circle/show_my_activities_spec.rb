require 'rails_helper'

describe "Show my activities", js: true do

  let(:circle)        { create(:circle, :with_admin_and_working_group) }
  let(:admin)         { circle.admin }
  let(:working_group) { circle.working_groups.first }

  let(:activities_page) { PageObject::Circle::MyActivities.new }

  let!(:task_where_admin_is_organizer) { create(:task, working_group: working_group, organizer: admin) }
  let!(:task_where_admin_is_volunteer) { create(:task, working_group: working_group, volunteer: admin) }

  let!(:supply_where_admin_is_organizer) { create(:supply, working_group: working_group, organizer: admin) }
  let!(:supply_where_admin_is_volunteer) { create(:supply, working_group: working_group, volunteer: admin) }

  before { activities_page.load(circle_id: circle.id, as: admin.id) }

  describe "Volunteered tasks and supplies" do

    it "shows only volunteered resources" do
      expect(activities_page).to have_task(task_where_admin_is_volunteer)
      expect(activities_page).to have_supply(supply_where_admin_is_volunteer)

      expect(activities_page).not_to have_task(task_where_admin_is_organizer)
      expect(activities_page).not_to have_supply(supply_where_admin_is_organizer)
    end
  end

  describe "Organized tasks and supplies" do

    it "shows only organized resources" do
      activities_page.tab_nav.organizing.click
      activities_page.tab_nav.wait_for_organizing_active
      expect(activities_page).to have_task(task_where_admin_is_organizer)
      expect(activities_page).to have_supply(supply_where_admin_is_organizer)

      expect(activities_page).not_to have_task(task_where_admin_is_volunteer)
      expect(activities_page).not_to have_supply(supply_where_admin_is_volunteer)
    end
  end

end