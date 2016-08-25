require 'rails_helper'

describe "Complete and reopen a supply", js: true do

  let(:circle)        { create(:circle, :with_admin_and_working_group) }
  let(:admin)         { circle.admin }
  let(:working_group) { circle.working_groups.first }

  let(:supply_page) { PageObject::Supply::Page.new }
  # when reusing the regular supply_page for some assertions I got intermittent errors;
  # not sure why. Maybe the page didn't "realize" it got reloaded.
  let(:new_supply_page) { PageObject::Supply::Page.new }

  before { supply_page.load_for(supply, as: admin) }

  describe "completing a supply" do

    context "when supply is incomplete" do
      let!(:supply) { create(:supply, working_group: working_group) }

      it "can be completed" do
        supply_page.edit_menu.open
        supply_page.edit_menu.complete.click
        # using new_supply_page, sic! see above.
        expect(new_supply_page).to have_urgency_complete
      end
    end
  end

  describe "reopening a supply" do

    context "when supply is completed" do

      let!(:supply) { create(:supply, :completed, working_group: working_group) }

      it "works" do
        supply_page.edit_menu.open
        supply_page.edit_menu.reopen.click
        # using new_supply_page, sic! see above.
        new_supply_page.wait_for_urgency_new
        expect(new_supply_page).to have_urgency_new
      end
    end

  end

end