require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the FeatureTogglesHelper. For example:
#
# describe FeatureTogglesHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe ApplicationHelper, type: :helper do

  it "returns true correctly" do
    Rails.configuration.x.feature_toggles.projects = true
    expect(helper.feature_enabled?(:projects)).to be(true)
    expect(helper.feature_enabled?("projects")).to be(true)
  end

  it "returns false correctly" do
    Rails.configuration.x.feature_toggles.projects = false
    expect(helper.feature_enabled?(:projects)).to be(false)
    expect(helper.feature_enabled?("projects")).to be(false)
  end

  it "returns false on nil correctly" do
    expect(helper.feature_enabled?(:toasters)).to be(false)
  end

end
