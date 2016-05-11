require 'rails_helper'

describe Task::Create do
  let(:user) { create(:user) }
  # I don't care about permissions at this point
  let(:ability) { double('Ability', 'can?': true) }
  let(:circle) { create(:circle)}
  let(:task) { build(:task) }

  describe '#new' do

    describe "#working_group_disabled?" do

      context "when one working group is available" do
        before do
          1.times { create(:working_group, circle: circle) }
        end
        it 'returns true' do
          form = Task::Create.new(user: user, task: task, circle: circle, ability: ability)
          expect(form.working_group_disabled?).to be(true)
        end
      end

      context "when more than one working group is available" do
        before do
          2.times { create(:working_group, circle: circle) }
        end
        it 'returns false' do
          form = Task::Create.new(user: user, task: task, circle: circle, ability: ability)
          expect(form.working_group_disabled?).to be(false)
        end
      end
    end

  end
end
