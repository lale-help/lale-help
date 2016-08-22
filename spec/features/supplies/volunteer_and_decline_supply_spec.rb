require 'rails_helper'

describe "Volunteer for and decline a supply", js: true do

  let(:circle)        { create(:circle, :with_admin_and_working_group) }
  let(:admin)         { circle.admin }
  let(:working_group) { circle.working_groups.first }

  let!(:supply) { create(:supply, working_group: working_group) }

  let(:supply_page) { PageObject::Supply::Page.new }

  describe "volunteering for a supply" do
    context "when on the supply page" do
      before { supply_page.load_for(supply, as: admin) }

      it "works" do
        supply_page.volunteer_button.click
        expect(supply_page).to have_decline_button
        expect(supply_page).not_to have_volunteer_button
        expect(supply_page).to have_helper(admin)
      end
    end
  end

  describe "declining from a supply" do
    context "when on the supply page" do

      before { supply_page.load_for(supply, as: admin) }

      context "when already volunteered" do

        before { supply_page.volunteer_button.click }

        it "works" do
          expect(supply_page).not_to have_volunteer_button
          supply_page.decline_button.click
          expect(supply_page).to have_volunteer_button
          expect(supply_page).not_to have_decline_button
          expect(supply_page).not_to have_helper(admin)
        end
      end

    end
  end

end