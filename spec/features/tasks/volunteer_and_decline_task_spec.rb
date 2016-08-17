require 'rails_helper'

describe "Volunteer for and decline a task", js: true do

  let(:circle)        { create(:circle, :with_admin_and_working_group) }
  let(:admin)         { circle.admin }
  let(:working_group) { circle.working_groups.first }

  let!(:task) { create(:task, working_group: working_group) }

  let(:task_page) { PageObject::Task::Page.new }

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
          expect(task_page).not_to have_volunteer_button
          task_page.decline_button.click
          expect(task_page).to have_volunteer_button
          expect(task_page).not_to have_decline_button
          expect(task_page.helper_names).not_to include(admin.name)
        end
      end

    end
  end

end