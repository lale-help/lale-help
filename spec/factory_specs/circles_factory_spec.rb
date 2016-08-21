require 'rails_helper'

describe "Circle factory" do

  let(:user_1) { create(:user) }
  let(:user_2) { create(:user) }
  let(:user_3) { create(:user) }

  describe "default" do
    context "when not giving attributes" do
      it "creates a simple circle" do
        circle = create(:circle)
        expect(circle).to be_a(Circle)
        expect(circle.name).to match(/Circle \d+/)
      end
    end
  end

  describe "adding admins" do
    context "when giving one" do
      it "correctly assigns the admins" do
        circle = create(:circle, admin: user_1)
        expect(circle.admins).to match_array([user_1])
      end
    end

    context "when giving two" do
      it "correctly assigns the admins" do
        circle = create(:circle, admins: [user_1, user_2])
        expect(circle.admins).to match_array([user_1, user_2])
      end
    end

  end

  describe "adding volunteers" do
    context "when giving one" do
      it "correctly assigns the volunteers" do
        circle = create(:circle, volunteer: user_1)
        expect(circle.volunteers).to match_array([user_1])
      end
    end

    context "when giving two" do
      it "correctly assigns the volunteers" do
        circle = create(:circle, volunteers: [user_1, user_2])
        expect(circle.volunteers).to match_array([user_1, user_2])
      end
    end
  end

  describe "adding admins and volunteers" do
    it "correctly assigns the admins and volunteers" do
      circle = create(:circle, admins: user_3, volunteers: [user_1, user_2])
      expect(circle.admins).to match_array([user_3])
      expect(circle.volunteers).to match_array([user_1, user_2])
    end
  end

  describe "the :with_admin trait" do
    it "assigns a new user as admin" do
      circle = create(:circle, :with_admin)
      expect(circle.admins.size).to eq(1)
      expect(circle.admins.first).to be_a(User)
    end
  end

  describe "the :with_volunteer trait" do
    it "assigns a new user as volunteer" do
      circle = create(:circle, :with_volunteer)
      expect(circle.volunteers.size).to eq(1)
      expect(circle.volunteers.first).to be_a(User)
    end

    describe "combining with :with_admin trait" do
      it "correctly assigns the admins and volunteers" do
        circle = create(:circle, :with_admin, :with_volunteer)
        expect(circle.admins.size).to eq(1)
        expect(circle.admins.first).to be_a(User)
        expect(circle.volunteers.size).to eq(1)
        expect(circle.volunteers.first).to be_a(User)
      end
    end

  end

  describe "the :with_admin_and_working_group trait" do
    it "assigns a new user as admin" do
      circle = create(:circle, :with_admin_and_working_group)
      expect(circle.admins.size).to eq(1)
      expect(circle.admins.first).to be_a(User)
    end
    it "creates a working group" do
      circle = create(:circle, :with_admin_and_working_group)
      expect(circle.working_groups.size).to eq(1)
    end
    it "makes the circle admin member of the working group" do
      circle = create(:circle, :with_admin_and_working_group)
      wg = circle.working_groups.first
      expect(wg.members).to eq([circle.admin])
    end
  end



end