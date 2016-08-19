require 'rails_helper'

describe "Working group factory" do

  describe "the default factory" do

    let(:user_1) { create(:user) }
    let(:user_2) { create(:user) }
    let(:user_3) { create(:user) }

    context "when not giving attributes" do
      it "creates a simple working group" do
        wg = create(:working_group)
        expect(wg).to be_a(WorkingGroup)
        expect(wg.name).to match(/Group \d+/)
      end
    end

    describe "adding admins" do
      context "when giving one" do
        it "correctly assigns the admins" do
          wg = create(:working_group, admin: user_1)
          expect(wg.active_admins).to match_array([user_1])
        end
      end

      context "when giving two" do
        it "correctly assigns the admins" do
          wg = create(:working_group, admins: [user_1, user_2])
          expect(wg.active_admins).to match_array([user_1, user_2])
        end
      end
    end

    describe "adding members" do
      context "when giving one" do
        it "correctly assigns the members" do
          wg = create(:working_group, member: user_1)
          expect(wg.members).to match_array([user_1])
        end
      end

      context "when giving two" do
        it "correctly assigns the members" do
          wg = create(:working_group, members: [user_1, user_2])
          expect(wg.members).to match_array([user_1, user_2])
        end
      end
    end

    describe "adding admins and members" do
      it "correctly assigns the admins and members" do
        wg = create(:working_group, admins: user_3, members: [user_1, user_2])
        expect(wg.active_admins).to match_array([user_3])
        expect(wg.members).to match_array([user_1, user_2])
      end
    end

    describe "the :with_members trait" do
      it "assigns the new users as volunteers" do
        wg = create(:working_group, :with_members)
        expect(wg.members.size).to eq(2)
        expect(wg.members.first).to be_a(User)
        expect(wg.members.second).to be_a(User)
      end
    end

  end

end