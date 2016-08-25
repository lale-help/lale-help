require 'rails_helper'

describe "Edit a supply", js: true do
  
  let(:circle)        { create(:circle, :with_admin_and_working_group) }
  let(:admin)         { circle.admin }
  let(:working_group) { circle.working_groups.first }

  let!(:supply) { create(:supply, working_group: working_group) }

  let(:supply_form) { PageObject::Supply::Form.new }
  
  context "with valid inputs" do
    let(:inputs) { attributes_for(:supply).merge(location: 'Atlanta') }

    before { supply_form.load(circle_id: circle.id, supply_id: supply.id, action: :edit, as: admin.id) }

    it "works" do
      supply_page = supply_form.submit_with(inputs)
      expect(supply_page).to have_flash("Supply was successfully updated")
      expect(supply_page.headline.text).to eq(inputs[:name])
      expect(supply_page.description.text).to eq(inputs[:description])
      expect(supply_page.location.text).to include(inputs[:location])
      expect(supply_page.due_date_as_date).to eq(inputs[:due_date])
    end
  end

end