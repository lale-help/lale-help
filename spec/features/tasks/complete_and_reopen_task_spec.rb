require 'rails_helper'

describe "Complete and reopen a task", js: true do

  let(:circle)        { create(:circle, :with_admin_and_working_group) }
  let(:admin)         { circle.admin }
  let(:working_group) { circle.working_groups.first }

  let(:task_page) { PageObject::Task::Page.new }
  # when reusing the regular supply_page I got intermediate errors;
  # not sure why. Maybe the page didn't "realize" it got reloaded.
  # using task_page.wait_for_urgency_new didn't help, either.
  let(:new_task_page) { PageObject::Task::Page.new }

  before { task_page.load_for(task, as: admin) }

  describe "completing a task" do

    context "when supply is incomplete" do
      let!(:task) { create(:supply, working_group: working_group) }


      it "works" do
        task_page.edit_menu.open
        task_page.edit_menu.complete.click
        expect(new_task_page).to have_urgency_complete
      end
    end
  end
  
  describe "reopening a task", :ci_ignore do

    context "when task is completed" do

      let!(:task) { create(:task, :completed, working_group: working_group) }

      it "works" do
        expect(task_page).to have_urgency_complete
        task_page.edit_menu.open
        task_page.edit_menu.reopen.click
        new_task_page.wait_for_urgency_new
        expect(new_task_page).to have_urgency_new
      end
    end

  end

end