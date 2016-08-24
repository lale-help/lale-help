require 'rails_helper'

describe "Invite to project", js: true do

  let!(:circle)        { create(:circle, :with_admin) }
  let(:admin)          { circle.admin }
  let!(:working_group) { create(:working_group, admin: admin, circle: circle) }
  let!(:project)       { create(:project, working_group: working_group, admin: admin) }

  let(:dashboard_page) { PageObject::Project::Dashboard.new }

  before { dashboard_page.load(circle_id: circle.id, project_id: project.id, as: admin.id) }

  describe "Invite working group" do
    context "working group has one member" do

      let!(:wg_member) { create(:working_group_member_role, working_group: working_group).user }

      it "invites the member" do
        dashboard_page.invite_working_group_button.click
        expect(dashboard_page).to have_flash("Invited 1 member.")
        expect(last_email.to).to eq([wg_member.email])
      end
    end
  end

  describe "Invite circle" do
    context "circle has one member" do

      let!(:circle_member) { create(:circle_member_role, circle: circle).user }

      it "invites the member" do
        dashboard_page.invite_circle_button.click
        expect(dashboard_page).to have_flash("Invited 1 member.")
        expect(last_email.to).to eq([circle_member.email])
      end
    end
  end

end