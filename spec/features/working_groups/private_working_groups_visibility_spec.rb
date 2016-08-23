require 'rails_helper'

describe 'Private Working Groups', js: true do
  let(:circle) { create(:circle) }
  let!(:circle_admin_role) { create :circle_role_admin, circle: circle }
  let(:user_1) { create(:user, primary_circle: circle) }
  let(:user_2) { create(:user, primary_circle: circle) }

  let(:public_group)  { create(:working_group, is_private: false, circle: circle) }
  let(:private_group) { create(:working_group, is_private: true , circle: circle) }

  before do
    create(:circle_role_volunteer, circle: circle, user: user_1)
    create(:circle_role_volunteer, circle: circle, user: user_2)

    public_group.roles.member.create(user: user_1)
    public_group.roles.member.create(user: user_2)

    private_group.roles.member.create(user: user_1)
  end

  it "is setup" do
    expect(circle_admin_role.persisted?).to eq(true)
    expect(circle.admin.email).to be_present

    expect(circle.volunteers).to include(user_1, user_2)

    expect(public_group.users).to include(user_1, user_2)

    expect(private_group.users).to include(user_1)
    expect(private_group.users).to_not include(user_2)
  end


  context "as private group member" do
    it "lets them see the working group" do
      visit(circle_path(circle, as: user_1))
      expect(page).to have_content(public_group.name)
      expect(page).to have_content(private_group.name)

      visit(circle_working_group_path(circle, private_group, as: user_1))
      expect(current_path).to eq(circle_working_group_path(circle, private_group))
    end
  end


  context "not as private group member" do
    it "lets them see only the public working group" do
      visit(circle_path(circle, as: user_2))
      expect(page).to have_content(public_group.name)
      expect(page).to_not have_link(circle_working_group_path(circle, private_group))

      visit(circle_working_group_path(circle, private_group, as: user_2))
      expect(current_path).to_not eq(circle_working_group_path(circle, private_group))
      expect(current_path).to eq(circle_path(circle))

      visit(circle_working_group_path(circle, public_group, as: user_2))
      expect(current_path).to eq(circle_working_group_path(circle, public_group))
    end
  end
end
