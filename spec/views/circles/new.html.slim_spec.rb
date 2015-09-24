require 'rails_helper'

RSpec.describe "circles/new", type: :view do
  before(:each) do
    assign(:circle, Circle.new())
  end

  it "renders new circle form" do
    render

    assert_select "form[action=?][method=?]", circles_path, "post" do
    end
  end
end
