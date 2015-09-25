require 'rails_helper'

RSpec.describe "tasks/index", type: :view do
  before(:each) do

    @volunteer = Volunteer.create!()
    @circle = Circle.create!(name: 'foo', location_text: "SF", admin: @volunteer)
    @working_group = WorkingGroup.create(name: "test working group", circle: @circle)
    assign(:tasks, [
      Task.create!(name: "test task1", working_group: @working_group),
      Task.create!(name: "test task2", working_group: @working_group)
    ])
  end

  it "renders a list of tasks" do
    render
  end
end
