require 'rails_helper'

describe "WorkingGroup::RemoveUser" do

  let!(:working_group) { create(:working_group) }
  # admin 1 is only admin
  let!(:admin_1) { create(:working_group_admin_role, working_group: working_group).user }
  # admin 2 is admin and member
  let!(:admin_2) { create(:working_group_admin_role, working_group: working_group).user }
  let!(:admin_2_membership) { create(:working_group_member_role, working_group: working_group, user: admin_2) }
  # member is only members
  let!(:member) { create(:working_group_member_role, working_group: working_group).user }

  context "Test setup" do
    it "is what is expected" do
      expect(working_group.users.count).to eq(3)
      expect(working_group.admins.count).to eq(2)
      expect(working_group.members.count).to eq(2)
      expect(working_group.admins).to include(admin_1)
      expect(working_group.admins).to include(admin_2)
    end
  end 

  context "Removing an admin role" do
    
    context "when group has more than one admin" do
      it "removes the admin role" do
        expect {
          WorkingGroup::RemoveUser.run!(role_type: :admin, working_group: working_group, user_id: admin_1.id)
        }.to change { working_group.admins.count }.by(-1)
        expect(working_group.admins).to eq([admin_2])
      end

      it "keeps the member role" do
        expect {
          WorkingGroup::RemoveUser.run!(role_type: :admin, working_group: working_group, user_id: admin_2.id)
        }.not_to change { working_group.members.count }
        expect(working_group.admins).to eq([admin_1])
        expect(working_group.members).to match_array([member, admin_2])
      end
    end

    context "when group has only one admin" do
      before { admin_1.destroy }
      it "doesn't remove the admin role" do
        expect {
          WorkingGroup::RemoveUser.run(role_type: :admin, working_group: working_group, user_id: admin_2.id)
        }.not_to change { working_group.admins.count }
        expect(working_group.admins).to eq([admin_2])
      end
    end
  end

  context 'Removing a member role' do
    context "when user is only member" do
      it "removes the member role" do
        expect {
          WorkingGroup::RemoveUser.run!(role_type: :member, working_group: working_group, user_id: member.id)
        }.to change { working_group.members.count }.by(-1)
        expect(working_group.admins).to match_array([admin_1, admin_2])
        expect(working_group.members).to eq([admin_2])
      end
    end
    context "when user is admin as well" do
      it "removes both roles" do
        expect {
          WorkingGroup::RemoveUser.run!(role_type: :member, working_group: working_group, user_id: admin_2.id)
        }.to change { working_group.admins.count }.by(-1)
        expect(working_group.admins).to eq([admin_1])
        expect(working_group.members).to eq([member])
      end
    end
  end

end