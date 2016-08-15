require 'rails_helper'

describe "Navigating to tasks", js: true do

  # FIXME simplify with new factories
  let(:circle)    { create(:circle, :with_admin) }
  let(:admin)     { circle.admin }
  let(:working_group) { create(:working_group, circle: circle, member: admin) }
  let!(:task) { create(:task, working_group: working_group) }

  let(:circle_dashboard) { PageObject::Circle::Dashboard.new }

  describe "task form" do

    let(:task_form) { PageObject::Task::Form.new }

    context 'when user is working group admin' do

      context "when on the circle dashboard" do

        before { circle_dashboard.load(circle_id: circle.id, as_id: admin.id) }

        it 'can be reached' do
          circle_dashboard.add_button.click
          circle_dashboard.task_button.click
          expect(task_form.title.text).to eq("Create a new Task")
        end
      end
    end
  end

  describe "existing task" do

    let(:task_page) { PageObject::Task::Page.new }

    context "when on the circle dashboard" do

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