require 'rails_helper'

RSpec.describe "working_groups/show", type: :view do
  before(:each) do
    @working_group = FactoryGirl.create(:working_group)
    @circle = @working_group.circle
  end

  it "renders attributes in <p>" do
    render
  end
end
