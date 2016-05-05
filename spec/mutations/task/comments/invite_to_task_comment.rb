require 'rails_helper'

describe Task::Comments::InviteToTaskComment do
  let(:task) { FactoryGirl.create(:task) }
  let(:invite_count) { 2 }
  let(:user) { FactoryGirl.create(:user, first_name: 'Generic', last_name: 'User') }

  context '#execute' do
    it 'creates a comment' do
      outcome = Task::Comments::InviteToTaskComment.run(task: task, invite_count: invite_count, user: user, message: 'copied')
      expect(outcome).to be_success
    end
    it 'fills the comment body with an internationalized message' do
      Timecop.freeze(Time.new(2016, 01, 01, 00, 00, 00)) do
        outcome = Task::Comments::InviteToTaskComment.run(task: task, invite_count: invite_count, user: user, message: 'copied')
        expect(outcome.result.body).to eq('Generic User invited 2 helpers to this task on on January 01, 2016.')
      end
    end
  end
end
