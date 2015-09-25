require 'rails_helper'

RSpec.describe "working_groups/new", type: :view do
  let(:circle){FactoryGirl.create(:circle)}
  let(:working_group){FactoryGirl.build(:working_group, circle: circle)}
  before(:each) do
    assign(:circle, circle)
    assign(:working_group, working_group)
  end

  it "renders new working_group form" do
    render
    # binding.pry
    assert_select "form[action=?][method=?]", circle_working_groups_path(circle), "post" do
    end
  end
end
