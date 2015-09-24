require 'rails_helper'

RSpec.describe "circles/index", type: :view do
  before(:each) do
    assign(:circles, [
      Circle.create!(),
      Circle.create!()
    ])
  end

  it "renders a list of circles" do
    render
  end
end
