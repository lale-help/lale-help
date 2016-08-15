require 'rails_helper'

describe "Task volunteer and decline spec", js: true do

  let(:circle)    { create(:circle, :with_admin) }
  let(:admin)     { circle.admin }

  let(:working_group) { create(:working_group, circle: circle, member: admin) }
  let!(:task) { create(:task, working_group: working_group) }

  let(:task_page) { PageObject::Task::Page.new }

  # FIXME move this spec to a different file
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

  describe "volunteering for a task" do
    context "when on the task page" do
      before { task_page.load_for(task, as: admin) }

      it "works" do
        task_page.volunteer_button.click
        expect(task_page).to have_decline_button
        expect(task_page).not_to have_volunteer_button
        expect(task_page.helper_names).to include(admin.name)
      end
    end
  end

  describe "declining from a task" do
    context "when on the task page" do

      before { task_page.load_for(task, as: admin) }

      context "when already volunteered" do

        before { task_page.volunteer_button.click }

        it "works" do
          task_page.decline_button.click
          expect(task_page).to have_volunteer_button
          expect(task_page).not_to have_decline_button
          expect(task_page.helper_names).not_to include(admin.name)
        end
      end

    end
  end

end