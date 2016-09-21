require 'rails_helper'

describe "Delete a project", js: true do

  let(:circle)        { create(:circle, :with_admin_and_working_group) }
  let(:admin)         { circle.admin }
  let(:working_group) { circle.working_groups.first }

  let!(:project) { create(:project, working_group: working_group, admin: admin) }

  let(:project_page) { PageObject::Project::Dashboard.new }

  before { project_page.load_for(project, as: admin) }

  describe "delete a project" do
    it "works" do
      project_page.edit_menu.open
      project_page.edit_menu.delete.click
      expect(project_page).to have_flash("Duccessfully deleted project.")
    end
  end

end