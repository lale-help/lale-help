require 'rails_helper'

RSpec.describe "tasks/edit", type: :view do
  before(:each) do
    @task = FactoryGirl.create(:task)
    @working_group = @task.working_group
    @working_group_names_and_ids = [@working_group.name, @working_group.id]
    @circle = @working_group.circle
  end

  it "renders the edit task form" do
    render

    assert_select "form[action=?][method=?]", circle_task_path(@circle, @task), "post" do
    end
  end
end
