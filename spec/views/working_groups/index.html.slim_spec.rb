require 'rails_helper'

RSpec.describe "working_groups/index", type: :view do
  before(:each) do
    assign(:working_groups, [
      WorkingGroup.create!(),
      WorkingGroup.create!()
    ])
  end

  it "renders a list of working_groups" do
    render
  end
end
