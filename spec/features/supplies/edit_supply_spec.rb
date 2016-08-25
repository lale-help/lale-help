require 'rails_helper'

describe "Edit a supply", js: true do
  
  let(:circle)        { create(:circle, :with_admin_volunteer_and_working_group) }
  let(:admin)         { circle.admin }
  let(:volunteer)     { circle.volunteer }
  let(:working_group) { circle.working_groups.first }

  let!(:supply) { create(:supply, working_group: working_group) }

  let(:supply_form) { PageObject::Supply::Form.new }
  
  context 'when user is working group admin' do

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

  # FIXME move permission / navigation check outta here. consider creating supply_access_spec or navigate_to_spec.
  context 'when user is working group volunteer' do

    let(:supply_page) { PageObject::Supply::Page.new }

    before { supply_form.load(circle_id: circle.id, supply_id: supply.id, action: :edit, as: volunteer.id) }

    it "does not work" do
      expect(supply_page).not_to have_selector('.button-super')
    end
  end
end