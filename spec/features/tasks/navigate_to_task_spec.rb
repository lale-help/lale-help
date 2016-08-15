require 'rails_helper'

describe "Navigating to tasks", js: true do

  let(:circle)    { create(:circle, :with_admin) }
  let(:admin)     { circle.admin }

  let(:working_group) { create(:working_group, circle: circle, member: admin) }
  let!(:task) { create(:task, working_group: working_group) }

  let(:task_page) { PageObject::Task::Page.new }

  describe "navigating to task page" do
    context "when on the circle dashboard" do

      let(:circle_dashboard) { PageObject::Circle::Dashboard.new }

      before { circle_dashboard.load(circle_id: circle.id, as_id: admin.id) }

      it "works" do
        circle_dashboard.tasks.first.click
        task_page.wait_for_page_title
        expect(task_page.page_title).to eq(task.name)
        expect(task_page.description.text).to eq(task.description)
      end

    end
  end

end