require 'rails_helper'

describe Circle::Role do

  let(:circle) { create(:circle) }
  let(:user)   { create(:user) }
  subject      { circle.roles.create(role_type: 'circle.admin', user: user) }

  it { is_expected.to be_active }

  describe "accredited?" do
    
    context "accredited_until is nil" do
      subject { build(:circle_role, accredited_until: nil) }
      it { is_expected.not_to be_accredited }
    end
    
    context "accredited_until is in the past" do
      subject { build(:circle_role, accredited_until: Date.today - 1.day) }
      it { is_expected.not_to be_accredited }
    end
    
    context "accredited_until is today" do
      subject { build(:circle_role, accredited_until: Date.today) }
      it { is_expected.to be_accredited }
    end
    
    context "accredited_until is in the future" do
      subject { build(:circle_role, accredited_until: Date.today + 1.day) }
      it { is_expected.to be_accredited }
    end

  end
end