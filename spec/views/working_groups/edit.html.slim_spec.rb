require 'rails_helper'

RSpec.describe "working_groups/edit", type: :view do
  before(:each) do
    @volunteer = Volunteer.create!()
    @circle = Circle.create!(name: 'foo', location_text: "SF", admin: @volunteer)
    @working_group = assign(:working_group, WorkingGroup.create!(name: "test working group", circle: @circle))
  end

  xit "renders the edit working_group form" do
    render

    assert_select "form[action=?][method=?]", circle_working_group_path(@working_group), "post" do
    end
  end
end
