require 'rails_helper'

describe "Add and remove working group organizers", js: true do
  
  let(:circle)        { create(:circle, :with_admin_and_working_group) }
  let(:admin)         { circle.admin }
  let(:working_group) { circle.working_groups.first }

  let(:roles_page) { PageObject::WorkingGroup::Roles.new(circle, working_group, admin) }  

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
