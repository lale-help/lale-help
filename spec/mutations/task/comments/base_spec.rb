require 'rails_helper'

describe Task::Comments::Base do
  let(:user) { create(:user, first_name: 'Generic', last_name: 'User') }

  context 'for tasks' do
    let(:task) { create(:task) }

    context '#execute' do
      it 'creates a comment' do
        outcome = Task::Comments::Base.run(task: task, user: user, message: 'user_assigned')
        expect(outcome).to be_success
      end
      it 'fills the comment body with an internationalized message' do
        Timecop.freeze(Time.parse("2016-01-01")) do
          outcome = Task::Comments::Base.run(task: task, user: user, message: 'user_assigned')
          expect(outcome.result.body).to eq('Generic User signed up for this task on January 01, 2016.')
        end
      end
      it 'creates a comment using the lale-bot user' do
        outcome = Task::Comments::Base.run(task: task, user: user, message: 'user_assigned')
        expect(outcome.result.commenter.name).to eq('Lale Bot')
      end

    end
  end

  context 'for supplies' do
    let(:supply) { create(:supply) }

    context '#execute' do
      it 'creates a comment' do
        outcome = Task::Comments::Base.run(task: supply, user: user, message: 'user_assigned')
        expect(outcome).to be_success
      end
      it 'fills the comment body with an internationalized message' do
        Timecop.freeze(Time.parse("2016-01-01")) do
          outcome = Task::Comments::Base.run(task: supply, user: user, message: 'user_assigned')
          expect(outcome.result.body).to eq('Generic User signed up for this supply on January 01, 2016.')
        end
      end
      it 'creates a comment using the lale-bot user' do
        outcome = Task::Comments::Base.run(task: supply, user: user, message: 'user_assigned')
        expect(outcome.result.commenter.name).to eq('Lale Bot')
      end

    end


  end

end
