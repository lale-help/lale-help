require 'rails_helper'

describe "Delete a supply", js: true do

  let(:circle)        { create(:circle, :with_admin_and_working_group) }
  let(:admin)         { circle.admin }
  let(:working_group) { circle.working_groups.first }

  let!(:supply) { create(:supply, working_group: working_group) }

  let(:supply_page) { PageObject::Supply::Page.new }

  before { supply_page.load_for(supply, as: admin) }

  describe "delete a supply" do
    it "works" do
      supply_page.edit_menu.open
      supply_page.edit_menu.delete.click
      expect(supply_page).to have_flash("Supply was successfully destroyed.")
    end
  end

end