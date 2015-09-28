require 'rails_helper'

RSpec.describe "tasks/new", type: :view do
  let(:working_group) { create(:working_group) }
  let(:circle)        { working_group.circle }
  let(:task)          { build(:task, working_group: working_group) }
  before(:each) do
    assign(:circle, circle)
    assign(:task, task)
  end

  it "renders new task form" do
    render

    assert_select "form[action=?][method=?]", circle_tasks_path(circle), "post" do
    end
  end
end
