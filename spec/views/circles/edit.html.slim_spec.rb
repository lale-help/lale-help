require 'rails_helper'

RSpec.describe "circles/edit", type: :view do
  let(:circle){ FactoryGirl.create(:circle) }
  before(:each) { assign(:circle, circle) }

  it "renders the edit circle form" do
    render

    assert_select "form[action=?][method=?]", circle_path(circle), "post" do
    end
  end
end
