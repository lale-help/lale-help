require 'rails_helper'

describe Task::Update do
  let(:user) { create(:user) }
  let(:ability) { Ability.new(user) }
  let(:task) { build(:task) }

  describe '#new' do

    describe "#working_group_disabled?" do

      it 'returns true' do
        form = Task::Update.new(user: user, task: task, circle: task.circle, ability: ability)
        expect(form.working_group_disabled?).to be(true)
      end

    end

  end
end
