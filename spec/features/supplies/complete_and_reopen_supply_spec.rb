require 'rails_helper'

describe "Complete and reopen a supply", js: true do

  let(:circle)        { create(:circle, :with_admin_and_working_group) }
  let(:admin)         { circle.admin }
  let(:working_group) { circle.working_groups.first }

  let!(:supply) { create(:supply, working_group: working_group) }

  let(:supply_page) { PageObject::Supply::Page.new }

  before { supply_page.load_for(supply, as: admin) }

  describe "completing a supply" do
    it "works" do
      supply_page.edit_menu.open
      supply_page.edit_menu.complete.click
      expect(supply_page).to be_completed
    end
  end

  describe "reopening a supply" do

    context "when supply is completed" do

      before do
        supply_page.edit_menu.open
        supply_page.edit_menu.complete.click
      end

      it "works" do
        expect(supply_page).to be_completed
        supply_page.edit_menu.open
        supply_page.edit_menu.reopen.click
        expect(supply_page).to be_new
      end
    end

  end

end