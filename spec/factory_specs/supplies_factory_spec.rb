require 'rails_helper'

describe "Supply factory" do

  let(:user_1) { create(:user) }
  let(:user_2) { create(:user) }

  describe "default factory" do
    it "creates an organizer" do
      supply = create(:supply)
      expect(supply.organizer).to be_a(User)
    end
  end
  
  describe "adding an organizer" do
    it "correctly assigns the organizer" do
      supply = create(:supply, organizer: user_1)
      expect(supply.organizer).to eq(user_1)
    end
  end

  describe "adding volunteer" do
    it "correctly assigns the volunteer" do
      supply = create(:supply, volunteer: user_1)
      expect(supply.volunteers).to match_array([user_1])
    end
  end

  describe "adding organizer and volunteer" do
    it "correctly assigns the organizer and volunteers" do
      supply = create(:supply, organizer: user_2, volunteer: user_1)
      expect(supply.organizer).to eq(user_2)
      expect(supply.volunteer).to eq(user_1)
    end
  end

  describe "the :with_admin trait" do
    it "assigns a new user as admin" do
      supply = create(:supply, :with_admin)
      expect(supply.organizer).to be_a(User)
    end
  end

  describe "the :with_volunteer trait" do
    it "assigns a new user as volunteer" do
      supply = create(:supply, :with_volunteer)
      expect(supply.volunteers.size).to eq(1)
      expect(supply.volunteers.first).to be_a(User)
    end

    describe "combining with :with_admin trait" do
      it "correctly assigns the organizer and volunteers" do
        supply = create(:supply, :with_admin, :with_volunteer)
        expect(supply.organizer).to be_a(User)
        expect(supply.volunteer).to be_a(User)
      end
    end

  end

end