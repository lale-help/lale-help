require 'rails_helper'

describe 'Navigate to a supply', js: true do

  let(:circle)        { create(:circle, :with_admin_and_working_group) }
  let(:admin)         { circle.admin }
  let(:working_group) { circle.working_groups.first }

  let(:circle_dashboard) { PageObject::Circle::Dashboard.new }

  describe "supply form" do

    let(:supply_form) { PageObject::Supply::Form.new }

    context 'when user is working group admin' do

      context "when on the circle dashboard" do

        before { circle_dashboard.load(circle_id: circle.id, as_id: admin.id) }

        it 'can be reached' do
          circle_dashboard.add_button.click
          circle_dashboard.supply_button.click
          expect(supply_form.title.text).to eq("Create a new Supply")
        end
      end
    end
  end

  describe "existing supply" do

    let!(:supply) { create(:supply, working_group: working_group) }
    let(:supply_page) { PageObject::Supply::Page.new }

    context 'when user is working group admin' do

      context "when on the circle dashboard" do

        before { circle_dashboard.load(circle_id: circle.id, as_id: admin.id) }

        it "can be reached" do
          circle_dashboard.tab_nav.supplies.click
          circle_dashboard.supplies.first.click
          supply_page.wait_for_page_title
          expect(supply_page.page_title).to eq(supply.name)
          expect(supply_page.description.text).to eq(supply.description)
        end

      end
    end
  end
end
