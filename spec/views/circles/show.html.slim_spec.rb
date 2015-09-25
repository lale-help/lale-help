require 'rails_helper'

RSpec.describe "circles/show", type: :view do
  before(:each) do
    @circle = assign(:circle, Circle.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
