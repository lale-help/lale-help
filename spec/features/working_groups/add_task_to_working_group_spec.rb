require 'rails_helper'

describe "Add Task to a Working Group", js: true do

  let(:circle)        { create(:circle, :with_admin) }
  let(:admin)         { circle.admin }
  let(:working_group) { create(:working_group, :with_members, circle: circle, admin: admin) }

  let(:dashboard_page)  { PageObject::WorkingGroup::Dashboard.new }
  # when reusing the regular page for some assertions I got intermittent errors;
  # not sure why. Maybe the page didn't "realize" it got reloaded.
  let(:dashboard_page2) { PageObject::WorkingGroup::Dashboard.new }
  let(:task_form)       { PageObject::Task::Form.new }
  let(:inputs)          { attributes_for(:task) }

  before { dashboard_page.load(circle_id: circle.id, wg_id: working_group.id, as: admin.id) }

  it "by clicking a button" do
    dashboard_page.add_task_button.click
    task_form.submit_with(inputs)

    dashboard_page2.load(circle_id: circle.id, wg_id: working_group.id, as: admin.id)
    dashboard_page2.when_loaded do
      dashboard_page2.tab_nav.tasks.click
      expect(dashboard_page2.tasks.count).to eq 1
    end
  end
end
