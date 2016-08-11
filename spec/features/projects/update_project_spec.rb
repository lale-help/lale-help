require 'rails_helper'

describe "Update project", type: :feature, js: true do
  
  let(:circle) { create(:circle) }

  # create an admin in the circle
  let(:circle_admin_role) { create(:circle_role_admin, circle: circle) }
  let(:admin) { circle_admin_role.user }

  # create a volunteer in the same circle
  let(:circle_volunteer_role) { create(:circle_role_volunteer, circle: circle) }
  let(:volunteer) { circle_volunteer_role.user }

  # this working group will contain the project
  let(:working_group) { create(:public_working_group, circle: circle) }

  let(:project) { create(:project, working_group: working_group) }

  before do
    # create the working group user roles (== memberships) for the admin and volunteer
    create(:working_group_admin_role, user: admin, working_group: working_group)
    create(:working_group_member_role, user: volunteer, working_group: working_group)

    # create project admin role
    create(:project_admin_role, project: project, user: admin)

    # When the setup data isn't trivial, I like to verify everything is set up as I expect it to. 
    # Ensuring this can significantly reduce debugging time when something doesn't work as expected later.
    # This is also good documentation for the next developer (and yourself in two months).
    expect(admin).to eq(circle.admin)
    expect(circle.users).to include(volunteer)
    expect(working_group.active_admins).to eq([admin])
    expect(working_group.active_users).to match_array([admin, volunteer])
    expect(project.admin).to eq(admin)
  end
    
  context "when on edit project page" do
    
    before { visit edit_circle_project_path(id: project, circle_id: circle, as: admin) }

    let(:project_form) { ProjectForm.new(type: :update) }

    context "when all mandatory fields are filled" do
      let(:project_attributes) { {name: "New working group name"} }
      it "updates the project" do
        project_page = project_form.submit_with(project_attributes)
        expect(project_page).to have_name(project_attributes[:name])
      end
    end

    context "when name is empty" do
      let(:project_attributes) { {name: ""} }
      it "shows an error message" do
        project_form.submit_with(project_attributes)
        expect(project_form).to be_invalid
        expect(project_form).to have_validation_error("Name can't be empty")
      end
    end
  end


end