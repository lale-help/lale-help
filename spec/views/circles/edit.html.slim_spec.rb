require 'rails_helper'

RSpec.describe "circles/edit", type: :view do
  before(:each) do
    @circle = assign(:circle, Circle.create!())
  end

  it "renders the edit circle form" do
    render

    assert_select "form[action=?][method=?]", circle_path(@circle), "post" do
    end
  end
end
