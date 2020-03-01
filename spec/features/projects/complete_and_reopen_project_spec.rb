require 'rails_helper'

describe "Complete and reopen a project", js: true do

  let(:circle)        { create(:circle, :with_admin_and_working_group) }
  let!(:admin)        { circle.admin }
  let(:working_group) { circle.working_groups.first }

  let(:project_page)     { PageObject::Project::Dashboard.new }
  let(:new_project_page) { PageObject::Project::Dashboard.new }
  let(:new_project_page2) { PageObject::Project::Dashboard.new }

  before { project_page.load_for(project, as: admin) }

  describe "completing a project" do

    context "when project is open" do
      let!(:project) { create(:project, :open, working_group: working_group, admin: admin) }

      it "is completed" do
        project_page.edit_menu.open
        project_page.edit_menu.complete.click
        expect(new_project_page).to be_completed
      end
    end
  end

  describe "reopening a project" do

    context "when project is completed" do

      let!(:project) { create(:project, :completed, working_group: working_group, admin: admin) }

      it "is open again" do
        expect(project_page).to be_completed
        project_page.edit_menu.open
        project_page.edit_menu.reopen.click
        expect(new_project_page2).to be_open
      end
    end

  end

end
