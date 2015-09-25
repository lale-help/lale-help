require 'rails_helper'

RSpec.describe "working_groups/show", type: :view do
  before(:each) do
    @volunteer = Volunteer.create!()
    @circle = Circle.create!(name: 'foo', location_text: "SF", admin: @volunteer)
    @working_group = assign(:working_group, WorkingGroup.create!(name: "test working group", circle: @circle))
  end

  it "renders attributes in <p>" do
    render
  end
end
