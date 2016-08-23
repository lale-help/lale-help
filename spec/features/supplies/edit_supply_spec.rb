require 'rails_helper'

describe "Edit a supply", js: true do
  
  let(:circle)        { create(:circle, :with_admin_volunteer_and_working_group) }
  let(:admin)         { circle.admin }
  let(:volunteer)     { circle.volunteer }
  let(:working_group) { circle.working_groups.first }

  let!(:supply) { create(:supply, working_group: working_group) }
  let(:supply_page) { PageObject::Supply::Page.new }

  let(:edit_form) { PageObject::Supply::Form.new }
  let(:edited_inputs) { attributes_for(:supply).merge(location: 'Atlanta') }
  
  context 'when user is working group admin' do

    before { supply_page.load_for(supply, as: admin) }

    it "works" do
      supply_page.edit_menu.open
      supply_page.edit_menu.edit.click
      edits_page = edit_form.submit_with(edited_inputs)

      expect(edits_page).to have_flash("Supply was successfully updated")
      expect(edits_page.headline.text).to eq(edited_inputs[:name])
      expect(edits_page.description.text).to eq(edited_inputs[:description])
      expect(edits_page.location.text).to include(edited_inputs[:location])
      expect(edits_page.due_date_as_date).to eq(edited_inputs[:due_date])

    end
  end

  context 'when user is working group volunteer' do

    before { supply_page.load_for(supply, as: volunteer) }

    it "does not work" do
      expect(supply_page).not_to have_selector('.button-super')
    end
  end
end