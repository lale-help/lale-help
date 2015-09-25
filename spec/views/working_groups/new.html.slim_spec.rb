require 'rails_helper'

RSpec.describe "working_groups/new", type: :view do
  before(:each) do
    assign(:working_group, WorkingGroup.new())
  end

  it "renders new working_group form" do
    render

    assert_select "form[action=?][method=?]", working_groups_path, "post" do
    end
  end
end
