require 'rails_helper'

describe "Navigating to a task", js: true do

  let(:circle)        { create(:circle, :with_admin_and_working_group) }
  let(:admin)         { circle.admin }
  let(:working_group) { circle.working_groups.first }

  let(:circle_dashboard) { PageObject::Circle::Dashboard.new }

  describe "task form" do

    let(:task_form) { PageObject::Task::Form.new }

    context 'when user is working group admin' do

      context "when on the circle dashboard" do

        before { circle_dashboard.load(circle_id: circle.id, as: admin.id) }

        it 'can be reached' do
          circle_dashboard.add_menu.open
          circle_dashboard.add_menu.task.click
          expect(task_form.title.text).to eq("Create a new Task")
        end
      end
    end
  end

  describe "existing task" do

    let!(:task)     { create(:task, working_group: working_group) }
    let(:task_page) { PageObject::Task::Page.new }

    context "when on the circle dashboard" do

      before { circle_dashboard.load(circle_id: circle.id, as: admin.id) }

      it "works" do
        circle_dashboard.tasks.first.name.click
        task_page.wait_for_headline
        expect(task_page.headline.text).to eq(task.name)
        expect(task_page.description.text).to eq(task.description)
      end

    end
  end

end