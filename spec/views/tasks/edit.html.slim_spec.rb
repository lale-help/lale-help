require 'rails_helper'

RSpec.describe "tasks/edit", type: :view do
  before(:each) do
    @task = assign(:task, Task.create!())
  end

  it "renders the edit task form" do
    render

    assert_select "form[action=?][method=?]", circle_task_path(@circle, @task), "post" do
    end
  end
end
