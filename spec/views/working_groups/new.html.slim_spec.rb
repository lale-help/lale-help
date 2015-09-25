require 'rails_helper'

RSpec.describe "working_groups/new", type: :view do
  before(:each) do
    @volunteer = Volunteer.create!()
    @circle = Circle.create!(name: 'foo', location_text: "SF", admin: @volunteer)
    @working_group = assign(:working_group, WorkingGroup.new(name: "test working group", circle: @circle))
  end

  xit "renders new working_group form" do
    render

    assert_select "form[action=?][method=?]", circle_working_groups_path(@circle), "post" do
    end
  end
end
