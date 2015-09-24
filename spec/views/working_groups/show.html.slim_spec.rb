require 'rails_helper'

RSpec.describe "working_groups/show", type: :view do
  before(:each) do
    @working_group = assign(:working_group, WorkingGroup.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
