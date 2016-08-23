require 'rails_helper'

describe "Project factory" do

  let(:user_1) { create(:user) }
  let(:user_2) { create(:user) }

  describe "adding admins" do
    context "when giving one" do
      it "correctly assigns the admins" do
        project = create(:project, admin: user_1)
        expect(project.admins).to match_array([user_1])
      end
    end

    context "when giving two" do
      it "correctly assigns the admins" do
        project = create(:project, admins: [user_1, user_2])
        expect(project.admins).to match_array([user_1, user_2])
      end
    end

  end

  describe "the :with_admin trait" do
    it "assigns a new user as admin" do
      project = create(:project, :with_admin)
      expect(project.admins.first).to be_a(User)
    end
  end

end