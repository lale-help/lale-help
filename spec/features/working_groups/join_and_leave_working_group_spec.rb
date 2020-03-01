require 'rails_helper'

describe "Join and leave a working group", js: true do

  let(:circle)        { create(:circle, :with_admin) }
  let(:circle_admin)  { circle.admin }
  # the working group has an admin, but circle_admin is *not* yet in the working group.
  let(:working_group) { create(:working_group, :with_admin, circle: circle) }

  let(:dashboard_page) { PageObject::WorkingGroup::Dashboard.new }

  before { dashboard_page.load(circle_id: circle.id, wg_id: working_group.id, as: circle_admin.id) }

  describe "joining a group" do

    it "can become member of the group" do
      dashboard_page.join_button.click
      expect(dashboard_page).to have_leave_button
      expect(dashboard_page).not_to have_join_button
      expect(dashboard_page).to have_volunteer(circle_admin)
    end

  end

  describe "leaving a group" do

    context "when currently member of the group" do

      before { dashboard_page.join_button.click }

      it "can leave the group" do
        expect(dashboard_page).not_to have_join_button
        dashboard_page.leave_button.click
        expect(dashboard_page).to have_join_button
        expect(dashboard_page).not_to have_leave_button
        expect(dashboard_page).not_to have_volunteer(circle_admin)
      end
    end
  end

end