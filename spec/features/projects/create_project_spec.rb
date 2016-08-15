require 'rails_helper'

describe "Create project", js: true do
  
  let(:circle)    { create(:circle, :with_admin, :with_volunteer) }
  let(:admin)     { circle.admin }
  let(:volunteer) { circle.volunteers.first }

  # this working group will be the default selection.
  let!(:working_group) { create(:public_working_group, circle: circle, admin: admin, member: volunteer) }

  # this working group will contain the project. It will actively be selected by the test.
  let!(:working_group_2) { create(:public_working_group, circle: circle, admin: admin, member: volunteer) }

  context "when on new project page" do

    let(:project_form) { PageObject::Project::Form.new }

    before { project_form.load(circle_id: circle.id, as_id: admin.id) }

    context "when all mandatory fields are filled" do
      let(:project_attributes) { attributes_for(:project).merge(organizer_name: volunteer.name, working_group_name: working_group_2.name) }
      it "creates the project" do
        project_page = project_form.submit_with(project_attributes)
        expect(project_page.project_name).to eq(project_attributes[:name])
        expect(project_page.organizer_name).to eq("Organized by #{project_attributes[:organizer_name]}")
        expect(project_page.working_group_name).to eq(project_attributes[:working_group_name])
      end
    end
    
    context "when no mandatory field is filled" do
      let(:project_attributes) { {} }
      it "shows all error messages" do
        project_form.submit_with(project_attributes)
        expect(project_form).to be_invalid
        expect(project_form).to have_validation_error("Name can't be empty")
      end
    end
  end


end