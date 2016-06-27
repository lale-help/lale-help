require 'rails_helper'

describe Task::Comments::Cloned do
  let(:task) { create(:task) }
  let(:cloned_task) { create(:task, name: 'Original Task') }
  let(:user) { create(:user, first_name: 'Generic', last_name: 'User') }

  context '#execute' do
    it 'creates a comment' do
      outcome = Task::Comments::Cloned.run(task: task, task_cloned: cloned_task, user: user)
      expect(outcome).to be_success
    end
    it 'fills the comment body with an internationalized message' do
      Timecop.freeze(Time.parse("2016-01-01")) do
        outcome = Task::Comments::Cloned.run(task: task, task_cloned: cloned_task, user: user)
        expect(outcome.result.body).to eq('This task was copied from task Original Task on January 01, 2016.')
      end
    end
  end
end
