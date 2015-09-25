require 'rails_helper'

RSpec.describe "tasks/new", type: :view do
  before(:each) do
    @volunteer = Volunteer.create!()
    @circle = Circle.create!(name: 'foo', location_text: "SF", admin: @volunteer)
    @working_group = WorkingGroup.create(name: "test working group", circle: @circle)
    assign(:task, Task.new(working_group: @working_group))
  end

  xit "renders new task form" do
    render

    assert_select "form[action=?][method=?]", circle_tasks_path(@circle), "post" do
    end
  end
end
