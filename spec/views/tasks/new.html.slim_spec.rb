require 'rails_helper'

RSpec.describe "tasks/new", type: :view do
  let(:circle){FactoryGirl.create(:circle)}
  let(:working_group){FactoryGirl.build(:working_group, circle: circle)}
  let(:task){FactoryGirl.build(:task, working_group: working_group)}
  before(:each) do
    assign(:circle, circle)
    assign(:working_group_names_and_ids, [working_group.name, working_group.id])
    assign(:task, task)
  end

  it "renders new task form" do
    render

    assert_select "form[action=?][method=?]", circle_tasks_path(circle), "post" do
    end
  end
end
