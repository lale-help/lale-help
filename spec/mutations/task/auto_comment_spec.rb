require 'rails_helper'

describe Task::AutoComment do
  let!(:bot)  { FactoryGirl.create(:user, first_name: 'Lale', last_name: 'Bot') }
  let(:task) { FactoryGirl.create(:task) }
  let(:user) { FactoryGirl.create(:user, first_name: 'Generic', last_name: 'User') }

  context '#execute' do
    it 'creates a comment' do
      Timecop.freeze(Time.new(2016, 01, 01, 00, 00, 00)) do
        outcome = Task::AutoComment.run(task: task, user: user, message: 'user_assigned')
        expect(outcome).to be_success
        expect(outcome.result.body).to eq('Generic User signed up for this task on January 01, 2016.')
        expect(outcome.result.commenter).to eq(bot)
      end
    end

  end
end
