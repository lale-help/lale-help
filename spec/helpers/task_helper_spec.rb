require 'rails_helper'

describe TaskHelper do
  describe "#working_group_options" do
    let  (:circle)         { create(:circle) }
    let! (:working_groups) { create_list(:working_group, 3, circle: circle) }

    it "returns 3 [name, id] paris representing the Working Groups under the Circle" do
      expect(working_group_options(circle)).to eq(working_groups.map{|wg| [wg.name, wg.id]})
    end
  end
end
