require 'rails_helper'

RSpec.describe "tasks/edit", type: :view do
  before(:each) do
    @volunteer = Volunteer.create!()
    @circle = Circle.create!(name: 'foo', location_text: "SF", admin: @volunteer)
    @working_group = WorkingGroup.create(name: "test working group", circle: @circle)
    @task = assign(:task, Task.create!(name: "test task", working_group: @working_group))
  end

  it "renders the edit task form" do
    render

    assert_select "form[action=?][method=?]", circle_task_path(@circle, @task), "post" do
    end
  end
end
