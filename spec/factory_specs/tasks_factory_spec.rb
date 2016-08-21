require 'rails_helper'

describe "Task factory" do

  let(:user_1) { create(:user) }
  let(:user_2) { create(:user) }
  let(:user_3) { create(:user) }

  describe "adding an organizer" do
    it "correctly assigns the organizer" do
      task = create(:task, organizer: user_1)
      expect(task.organizer).to eq(user_1)
    end
  end

  describe "adding volunteers" do
    context "when giving one" do
      it "correctly assigns the volunteers" do
        task = create(:task, volunteer: user_1)
        expect(task.volunteers).to match_array([user_1])
      end
    end

    context "when giving two" do
      it "correctly assigns the volunteers" do
        task = create(:task, volunteers: [user_1, user_2])
        expect(task.volunteers).to match_array([user_1, user_2])
      end
    end
  end

  describe "adding organizer and volunteers" do
    it "correctly assigns the organizer and volunteers" do
      task = create(:task, organizer: user_3, volunteers: [user_1, user_2])
      expect(task.organizer).to eq(user_3)
      expect(task.volunteers).to match_array([user_1, user_2])
    end
  end

  describe "the :with_admin trait" do
    it "assigns a new user as admin" do
      task = create(:task, :with_admin)
      expect(task.organizer).to be_a(User)
    end
  end

  describe "the :with_volunteer trait" do
    it "assigns a new user as volunteer" do
      task = create(:task, :with_volunteer)
      expect(task.volunteers.size).to eq(1)
      expect(task.volunteers.first).to be_a(User)
    end

    describe "combining with :with_admin trait" do
      it "correctly assigns the organizer and volunteers" do
        task = create(:task, :with_admin, :with_volunteer)
        expect(task.organizer).to be_a(User)
        expect(task.volunteers.size).to eq(1)
        expect(task.volunteers.first).to be_a(User)
      end
    end

  end

  describe "the :with_volunteers trait" do
    it "assigns the new users as volunteers" do
      task = create(:task, :with_volunteers)
      expect(task.volunteers.size).to eq(2)
      expect(task.volunteers.first).to be_a(User)
      expect(task.volunteers.second).to be_a(User)
    end
  end

end