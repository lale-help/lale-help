require 'rails_helper'

RSpec.describe "tasks/edit", type: :view do
  let(:task)    { create(:task) }
  let(:circle)  { task.working_group.circle }
  before(:each) do
    assign(:task,   task)
    assign(:circle, circle)
  end

  it "renders the edit task form" do
    render

    assert_select "form[action=?][method=?]", circle_task_path(circle, task), "post" do
    end
  end
end
