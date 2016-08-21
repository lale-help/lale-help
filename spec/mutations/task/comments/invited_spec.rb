require 'rails_helper'

describe Task::Comments::Invited do
  let(:task) { create(:task) }
  let(:invite_count) { 2 }
  let(:user) { create(:user, first_name: 'Generic', last_name: 'User') }

  context '#execute' do
    it 'creates a comment' do
      outcome = Task::Comments::Invited.run(item: task, invite_count: invite_count, user: user)
      expect(outcome).to be_success
    end
    it 'fills the comment body with an internationalized message' do
      Timecop.freeze(Time.parse("2016-01-01")) do
        outcome = Task::Comments::Invited.run(item: task, invite_count: invite_count, user: user)
        expect(outcome.result.body).to eq('Generic User invited 2 helpers to this task on January 01, 2016.')
      end
    end
  end
end
