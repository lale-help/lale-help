require 'rails_helper'

RSpec.describe "working_groups/edit", type: :view do
  before(:each) do
    @working_group = assign(:working_group, WorkingGroup.create!())
  end

  it "renders the edit working_group form" do
    render

    assert_select "form[action=?][method=?]", working_group_path(@working_group), "post" do
    end
  end
end
