require 'rails_helper'

describe Task::Comments::Cloned do
  let(:task) { FactoryGirl.create(:task) }
  let(:cloned_task) { FactoryGirl.create(:task, name: 'Original Task') }
  let(:user) { FactoryGirl.create(:user, first_name: 'Generic', last_name: 'User') }

  context '#execute' do
    it 'creates a comment' do
      outcome = Task::Comments::Cloned.run(task: task, task_cloned: cloned_task, user: user, message: 'copied')
      expect(outcome).to be_success
    end
    it 'fills the comment body with an internationalized message' do
      Timecop.freeze(Time.new(2016, 01, 01, 00, 00, 00)) do
        outcome = Task::Comments::Cloned.run(task: task, task_cloned: cloned_task, user: user, message: 'copied')
        expect(outcome.result.body).to eq('This task was copied from task Original Task on January 01, 2016.')
      end
    end
  end
end
