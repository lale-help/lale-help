require 'rails_helper'

describe "Create project", js: true do
  
  let(:circle)    { create(:circle, :with_admin, :with_volunteer) }
  let(:admin)     { circle.admin }
  let(:volunteer) { circle.volunteers.first }

  let!(:working_group) { create(:public_working_group, circle: circle, admin: admin, member: volunteer) }

  let(:project_form) { PageObject::Project::Form.new }

  context "when only required fields are filled" do

    let(:inputs) { attributes_for(:project) }
    before { project_form.load(circle_id: circle.id, as: admin.id) }

    it "creates the project" do
      project_page = project_form.submit_with(inputs)
      expect(project_page.name.text).to eq(inputs[:name])
      expect(project_page.organizer.text).to eq("Organized by #{admin.name}")
      expect(project_page.working_group.text).to eq(working_group.name)
    end  
  end

  context "when all fields are filled" do

    let!(:working_group_2) { create(:public_working_group, circle: circle, admin: admin, member: volunteer) }
    let(:inputs) { attributes_for(:project).merge(organizer_name: volunteer.name, working_group_name: working_group_2.name) }
    before { project_form.load(circle_id: circle.id, as: admin.id) }

    it "creates the project" do
      project_page = project_form.submit_with(inputs)
      expect(project_page.name.text).to eq(inputs[:name])
      expect(project_page.description.text).to eq(inputs[:description])
      expect(project_page.organizer.text).to eq("Organized by #{inputs[:organizer_name]}")
      expect(project_page.working_group.text).to eq(inputs[:working_group_name])
    end
  end
  
  context "when no mandatory field is filled" do
    let(:inputs) { {} }
    before { project_form.load(circle_id: circle.id, as: admin.id) }
    it "shows all error messages" do
      project_form.submit_with(inputs)
      expect(project_form).to be_invalid
      expect(project_form).to have_validation_error("Please enter a name")
    end
  end

end
