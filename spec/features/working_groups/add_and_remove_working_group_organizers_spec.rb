require 'rails_helper'

describe "Add and remove working group organizers", js: true do

  let(:circle)        { create(:circle, :with_admin_and_working_group) }
  let(:admin)         { circle.admin }
  let(:working_group) { circle.working_groups.first }

  let(:roles_page) { PageObject::WorkingGroup::Roles.new(circle, working_group, admin) }

  describe "add" do

    context "circle has a member that's not in the working group yet" do

      let!(:circle_member) { create(:circle_role_volunteer, circle: circle).user }

      before { roles_page.load_for(:organizers) }
      before { expect(roles_page).to have_no_users }

      it "can be added" do
        roles_page.user_dropdown.select(circle_member.list_name)
        # For a reason I wasn't able to debug in half a day, the div.field-row which contains the button
        # has a "display:none", but only in the test. So a regular .click can't access the button since
        # it is not visible. This will not work with selenium, though
        roles_page.add_button.trigger(:click)
        # wait for the page to update. normally I would use
        # roles_page.wait_for_users but since we're still on the same page after the reload,
        # that would immediately trigger true and continue.
        sleep 1
        expect(roles_page.organizers).to eq([circle_member.list_name])
      end
    end
  end

  describe "remove" do

    context "working group has two organizers" do

      let!(:organizers) do
        create_list(:working_group_organizer_role, 2, working_group: working_group).map do |role|
          role.user
        end
      end

      before { roles_page.load_for(:organizers) }

      it "one organizer can be removed" do
        expect(roles_page.organizers).to eq(organizers.map(&:name))
        roles_page.users.first.remove_button.click
        expect(roles_page.organizers).to eq([organizers.last.name])
      end
    end

  end

end
