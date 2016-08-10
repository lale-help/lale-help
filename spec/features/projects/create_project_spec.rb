require 'rails_helper'

describe "Create project", type: :feature, js: true do
  
  let(:circle) { create(:circle) }

  # create an admin in the circle
  let(:circle_admin_role) { create(:circle_role_admin, circle: circle) }
  let(:admin) { circle_admin_role.user }

  # create a volunteer in the same circle
  let(:circle_volunteer_role) { create(:circle_role_volunteer, circle: circle) }
  let(:volunteer) { circle_volunteer_role.user }

  # this working group will be the default selection.
  let(:working_group) { create(:public_working_group, circle: circle) }
  # this working group will contain the project. It will actively be selected by the test.
  let(:working_group_2) { create(:public_working_group, circle: circle) }

  before do
    # create the working group user roles (== memberships) for the admin and volunteer
    create(:working_group_admin_role, user: admin, working_group: working_group)
    create(:working_group_member_role, user: volunteer, working_group: working_group)

    # create the working group user roles (== memberships) for the admin and volunteer
    create(:working_group_admin_role, user: admin, working_group: working_group_2)
    create(:working_group_member_role, user: volunteer, working_group: working_group_2)

    # When the setup data isn't trivial, I like to verify everything is set up as I expect it to. 
    # Ensuring this can significantly reduce debugging time when something doesn't work as expected later.
    # This is also good documentation for the next developer (and yourself in two months).
    expect(admin).to eq(circle.admin)
    expect(circle.users).to include(volunteer)
    expect(working_group.active_admins).to eq([admin])
    expect(working_group.active_users).to match_array([admin, volunteer])
    expect(working_group_2.active_admins).to eq([admin])
    expect(working_group_2.active_users).to match_array([admin, volunteer])
  end
    
  context "when logged in as admin" do
    
    before { visit circle_path(circle, as: admin) }

    let(:project_on_page) { ProjectOnPage.new(project_attributes) }

    context "when all mandatory fields are filled" do
      let(:project_attributes) { attributes_for(:project).merge(organizer_name: volunteer.name, working_group_name: working_group_2.name) }
      it "creates the project" do
        project_on_page.create
        expect(project_on_page).to be_created
      end
    end

    context "when no mandatory field is filled" do
      let(:project_attributes) { {} }
      it "shows all error messages" do
        project_on_page.create
        expect(project_on_page).to be_invalid
        expect(project_on_page).to have_validation_error("Name can't be empty")
      end
    end
  end


end