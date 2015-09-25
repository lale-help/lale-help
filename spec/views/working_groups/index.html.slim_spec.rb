require 'rails_helper'

RSpec.describe "working_groups/index", type: :view do
  before(:each) do
    @circle = FactoryGirl.create(:circle)
    assign(:working_groups, [
      FactoryGirl.create(:working_group, circle: @circle),
      FactoryGirl.create(:working_group, circle: @circle)
    ])
  end

  it "renders a list of working_groups" do
    render
  end
end
