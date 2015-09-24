require 'rails_helper'

RSpec.describe "tasks/new", type: :view do
  before(:each) do
    assign(:task, Task.new())
  end

  it "renders new task form" do
    render

    assert_select "form[action=?][method=?]", circle_tasks_path(@circle), "post" do
    end
  end
end
