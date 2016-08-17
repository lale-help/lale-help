require 'rails_helper'

describe "Manage working group roles", js: true do
  
  let(:circle)        { create(:circle, :with_admin_and_working_group) }
  let(:admin)         { circle.admin }
  let(:working_group) { circle.working_groups.first }

  let(:roles_page) { PageObject::WorkingGroup::Roles.new(circle, working_group, admin) }  

  describe "Organizers" do

    context "working group has two organizers" do

      let!(:organizers) do
        create_list(:working_group_organizer_role, 2, working_group: working_group).map do |role| 
          role.user
        end
      end

      describe "remove" do

        before { roles_page.load_for(:organizers) }

        it "one organizer can be removed" do
          expect(roles_page.organizers).to eq(organizers.map(&:name))
          roles_page.users.first.remove_button.click
          expect(roles_page.organizers).to eq([organizers.last.name])
        end
      end
    end
  end

  describe "Volunteers" do

    describe "add", js: false do
    
      context "circle has a member that's not in the working group yet" do
        let!(:circle_member) { create(:circle_role_volunteer, circle: circle).user }

        before { roles_page.load_for(:members) }
        it "can be added" do
          expect do 
            roles_page.add_button.click 
            roles_page.user_select.select(circle_member.name)
          end.to change { roles_page.volunteers.count }.by(1)
        end
      end
    end

    describe "remove" do

      context "working group has two volunteers" do

        # note: admin is already a volunteer in the working group
        let!(:volunteer) { create(:working_group_volunteer_role, working_group: working_group).user }

        before { roles_page.load_for(:members) }

        it "one volunteer can be removed" do
          expect(roles_page.volunteers).to eq([admin.name, volunteer.name])
          roles_page.users.first.remove_button.click
          expect(roles_page.volunteers).to eq([volunteer.name])
        end
      end
    end
  end

end
