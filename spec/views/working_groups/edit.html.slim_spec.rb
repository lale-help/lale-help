require 'rails_helper'

RSpec.describe "working_groups/edit", type: :view do
  let(:circle){FactoryGirl.create(:circle)}
  let(:working_group){FactoryGirl.create(:working_group, circle: circle)}

  before(:each) do
    assign(:circle, circle)
    assign(:working_group, working_group)
  end

  it "renders the edit working_group form" do
    render

    assert_select "form[action=?][method=?]", circle_working_group_path(circle, working_group), "post" do
    end
  end
end
