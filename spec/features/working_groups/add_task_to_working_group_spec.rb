require 'rails_helper'

describe "Add Task to a Working Group", js: true do

  let(:circle)        { create(:circle, :with_admin) }
  let(:admin)         { circle.admin }
  let(:working_group) { create(:working_group, :with_members, circle: circle, admin: admin) }

  let(:dashboard_page)     { PageObject::WorkingGroup::Dashboard.new }
  let(:new_dashboard_page) { PageObject::WorkingGroup::Dashboard.new }
  let(:task_form)          { PageObject::Task::Form.new }
  let(:inputs)             { attributes_for(:task) }

  before { dashboard_page.load(circle_id: circle.id, wg_id: working_group.id, as: admin.id) }

  it "by clicking a button" do
    dashboard_page.add_task_button.click
    task_form.submit_with(inputs)

    new_dashboard_page.load(circle_id: circle.id, wg_id: working_group.id, as: admin.id)
    new_dashboard_page.when_loaded do
      expect(dashboard_page.tasks.count).to eq 1
    end
  end
end
