require 'rails_helper'

describe Task::Update do
  let(:user) { create(:user) }
  let(:ability) { Ability.new(user) }
  let(:task) { create(:task) }

  describe '#new' do

    describe "#project_disabled?" do

      context "when task has no project" do
        it 'returns true' do
          form = Task::Update.new({}, user: user, task: task, circle: task.circle, ability: ability)
          expect(form.project_disabled?).to be(true)
        end
      end

      context "when task has a project" do
        before { task.update_attribute(:project, create(:project)) }
        
        it 'returns true' do
          form = Task::Update.new({}, user: user, task: task, circle: task.circle, ability: ability)
          expect(form.project_disabled?).to be(true)
        end
      end

    end

  end
end
