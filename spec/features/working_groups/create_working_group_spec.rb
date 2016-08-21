require 'rails_helper'

describe "Create working group", js: true do
  
  let(:circle)    { create(:circle, :with_admin, :with_volunteer) }
  let(:admin)     { circle.admin }

  let(:wg_form) { PageObject::WorkingGroup::Form.new }
  let(:wg_page) { PageObject::WorkingGroup::Dashboard.new }

  context "when only required fields are filled" do

    let(:inputs) { attributes_for(:working_group, organizer_name: admin.name) }
    before { wg_form.load(circle_id: circle.id, as: admin.id) }

    it "creates the working group" do
      working_groups_page = wg_form.submit_with(inputs)
      working_groups_page.when_loaded do 
        expect(working_groups_page.working_groups.first.name.text).to eq(inputs[:name])
        expect(working_groups_page.working_groups.first.organizers.first.text).to include(inputs[:organizer_name])
      end
    end  
  end

  context "when no mandatory field is filled" do
    let(:inputs) { {} }
    before { wg_form.load(circle_id: circle.id, as: admin.id) }
    it "shows all error messages" do
      wg_form.submit_with(inputs)
      expect(wg_form).to be_invalid
      expect(wg_form).to have_validation_error("Please enter a name")
      # due to the way mutations work not all errors are displayed at once. only when name is set,
      # the organizer is validated.
      wg_form.name.set('Working group 42')
      wg_form.submit_button.click
      expect(wg_form).to have_validation_error("Please choose an organizer")
    end
  end

end
