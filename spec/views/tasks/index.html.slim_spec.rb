require 'rails_helper'

RSpec.describe "tasks/index", type: :view do
  before(:each) do
    working_group = FactoryGirl.create(:working_group)
    @circle = working_group.circle
    assign(:tasks, [
      FactoryGirl.create(:task, working_group: working_group),
      FactoryGirl.create(:task, working_group: working_group)
    ])
    allow(view).to receive(:current_user).and_return(@circle.admin)
  end

  it "renders a list of tasks" do
    render
  end
end
