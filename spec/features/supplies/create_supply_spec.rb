require 'rails_helper'

describe "Create a supply", js: true do
  
  let(:circle)        { create(:circle, :with_admin_and_working_group) }
  let(:admin)         { circle.admin }
  let(:working_group) { circle.working_groups.first }

  let(:supply_form) { PageObject::Supply::Form.new }

  before { supply_form.load(circle_id: circle.id, action: :new, as: admin.id) }

  context "when only required attributes are filled" do
    let(:inputs) { attributes_for(:supply).merge(location: 'Munich') }
    it "creates the supply" do
      supply_page = supply_form.submit_with(inputs)
      expect(supply_page.headline.text).to eq(inputs[:name])
      expect(supply_page.description.text).to eq(inputs[:description])
      expect(supply_page.location.text).to include(inputs[:location])
      expect(supply_page.due_date_as_date).to eq(inputs[:due_date])
      expect(supply_page.working_group.text).to eq(working_group.name)
      expect(supply_page.organizer.text).to eq("Organized by #{admin.name}")
      expect(supply_page).not_to have_project
    end
  end

  context "when no mandatory field is filled" do
    let(:inputs) { {} }
    it "shows all error messages" do
      supply_form.submit_with(inputs)
      expect(supply_form).to be_invalid
      expect(supply_form).to have_validation_error("Please enter a name")
      expect(supply_form).to have_validation_error("Please enter a due date")
      expect(supply_form).to have_validation_error("Please enter a description")
      expect(supply_form).to have_validation_error("Please enter a location")
    end
  end
end
