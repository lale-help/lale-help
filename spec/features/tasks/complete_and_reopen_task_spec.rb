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
      task_page.edit_button.click
      task_page.complete_button.click
      expect(task_page).to be_completed
    end
  end

  describe "reopening a task" do

    context "when task is completed" do

      before do
        task_page.edit_button.click
        task_page.complete_button.click
      end

      it "works" do
        expect(task_page).to be_completed
        task_page.edit_button.click
        task_page.reopen_button.click
        expect(task_page).to be_new
      end
    end

  end

end