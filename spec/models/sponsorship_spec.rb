require 'rails_helper'

RSpec.describe Sponsorship, type: :model do

  it { is_expected.to validate_presence_of(:circle_id) }
  it { is_expected.to validate_presence_of(:sponsor_id) }
  it { is_expected.to validate_presence_of(:starts_on) }
  it { is_expected.to validate_presence_of(:ends_on) }

  it { is_expected.to belong_to(:circle).class_name(Circle) }
  it { is_expected.to belong_to(:sponsor).class_name(Sponsor) }

  describe "#current" do

    context "no sponsorships at all" do
      it "returns an empty array" do
        expect(Sponsorship.current).to eq([])
      end
    end

    context "one current sponsorship" do
      let!(:sponsorship) { create(:sponsorship, :current) }
      it "returns one sponsorship" do
        expect(Sponsorship.current).to eq([sponsorship])
      end
    end

    context "two current sponsorships" do
      let!(:sponsorship_1) { create(:sponsorship, :current) }
      let!(:sponsorship_2) { create(:sponsorship, :current) }
      it "returns two sponsorships" do
        expect(Sponsorship.current).to match_array([sponsorship_1, sponsorship_2])
      end
    end

    context "has one sponsorship that ends today, and one that starts today" do
      let!(:sponsorship_1) { create(:sponsorship, starts_on: Date.today - 1.year, ends_on: Date.today) }
      let!(:sponsorship_2) { create(:sponsorship, starts_on: Date.today, ends_on: Date.today + 1.year) }
      it "returns both of them (start and end date are both inclusive" do
        expect(Sponsorship.current).to match_array([sponsorship_1, sponsorship_2])
      end
    end

    context "has one sponsorship that starts tomorrow" do
      let!(:sponsorship) { create(:sponsorship, :future, starts_on: Date.today + 1.day) }
      it "returns an empty array" do
        expect(Sponsorship.current).to eq([])
      end
    end

    context "one past sponsorship" do
      let!(:sponsorship) { create(:sponsorship, :past) }
      it "returns an empty array" do
        expect(Sponsorship.current).to eq([])
      end
    end

    context "one future sponsorship" do
      let!(:sponsorship) { create(:sponsorship, :future) }
      it "returns an empty array" do
        expect(Sponsorship.current).to eq([])
      end
    end

  end

  describe "#validations" do
    describe "validate start date is smaller or equal to end date" do
      context "when start and end date are equal" do
        let(:sponsorship) { build(:sponsorship, starts_on: Date.today, ends_on: Date.today) }
        it "record is valid" do
          expect(sponsorship).to be_valid
        end
      end
      context "when start date is before end date" do
        let(:sponsorship) { build(:sponsorship, starts_on: Date.today - 1.day, ends_on: Date.today) }
        it "record is valid" do
          expect(sponsorship).to be_valid
        end
      end
      context "when start date is after end date" do
        let(:sponsorship) { build(:sponsorship, starts_on: Date.today + 1.day, ends_on: Date.today) }
        it "record is invalid" do
          expect(sponsorship).not_to be_valid
        end
      end
      end
  end
end
