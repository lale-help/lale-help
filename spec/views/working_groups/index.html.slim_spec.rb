require 'rails_helper'

RSpec.describe "working_groups/index", type: :view do
  before(:each) do
    @volunteer = Volunteer.create!()
    @circle = Circle.create!(name: 'foo', location_text: "SF", admin: @volunteer)
    assign(:working_groups, [
      WorkingGroup.create!(name: "test working group", circle: @circle),
      WorkingGroup.create!(name: "test working group2", circle: @circle)
    ])
  end

  it "renders a list of working_groups" do
    render
  end
end
