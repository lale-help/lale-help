require 'rails_helper'

describe "Show helper list", js: true do

  let(:circle)        { create(:circle, :with_admin_and_working_group) }
  let(:admin)         { circle.admin }
  let(:working_group) { circle.working_groups.first }

  let(:helpers_page) { PageObject::Circle::Members.new }


  describe "all helpers" do

    context "circle has an admin and a volunteer" do

      let!(:circle_member) { create(:circle_role_volunteer, circle: circle).user }
      before { helpers_page.load(circle_id: circle.id, as: admin.id) }

      it "shows both" do
        expect(helpers_page).to have_helper(admin)
        expect(helpers_page).to have_helper(circle_member)
      end
    end
  end

  describe "organizers" do
    context "circle has an admin and a volunteer" do

      let!(:circle_member) { create(:circle_role_volunteer, circle: circle).user }
      before { helpers_page.load(circle_id: circle.id, as: admin.id) }

      it "shows only organizers" do
        helpers_page.tab_nav.organizers.click
        expect(helpers_page).to have_helper(admin)
        expect(helpers_page).not_to have_helper(circle_member)
      end
    end
  end

end