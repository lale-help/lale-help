require 'rails_helper'

describe Task::Create do
  let(:user) { create(:user) }
  let(:ability) { Ability.new(user) }
  let(:task) { build(:task) }

  describe '#new' do

    describe "#project_disabled?" do

      context "when task has no project" do
        it 'returns false' do
          form = Task::Create.new({}, user: user, task: task, circle: task.circle, ability: ability)
          expect(form.project_disabled?).to be(false)
        end
      end

      context "when task has a project" do
        before { task.project = create(:project) }
        it 'returns true' do
          form = Task::Create.new({}, user: user, task: task, circle: task.circle, ability: ability)
          expect(form.project_disabled?).to be(true)
        end
      end

    end

  end
end
