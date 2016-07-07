require 'rails_helper'

RSpec.describe Sponsor, type: :model do

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_uniqueness_of(:name) }
  it { is_expected.to have_many(:sponsorships).class_name(Sponsorship) }
  # 
end
