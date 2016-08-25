require 'rails_helper'

describe "Complete and reopen a task", js: true do

  let(:circle)        { create(:circle, :with_admin_and_working_group) }
  let(:admin)         { circle.admin }
  let(:working_group) { circle.working_groups.first }

  let!(:task) { create(:task, working_group: working_group) }

  let(:task_page) { PageObject::Task::Page.new }

  before { task_page.load_for(task, as: admin) }

  describe "completing a task" do
    it "works" do
      task_page.edit_menu.open
      task_page.edit_menu.complete.click
      expect(task_page).to have_urgency_complete
    end
  end

  describe "reopening a task" do

    context "when task is completed" do

      before do
        task_page.edit_menu.open
        task_page.edit_menu.complete.click
      end

      it "works" do
        expect(task_page).to have_urgency_complete
        task_page.edit_menu.open
        task_page.edit_menu.reopen.click
        expect(task_page).to have_urgency_new
      end
    end

  end

end