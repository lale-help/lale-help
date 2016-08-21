require 'rails_helper'

describe Comment::AutoComment do
  let(:user) { create(:user, first_name: 'Generic', last_name: 'User') }

  context 'for tasks' do
    let(:task) { create(:task) }

    context '#execute' do
      it 'creates a comment' do
        outcome = Comment::AutoComment.run(item: task, user: user, message: 'completed')
        expect(outcome).to be_success
      end
      it 'fills the comment body with an internationalized message' do
        Timecop.freeze(Time.parse("2016-01-01")) do
          outcome = Comment::AutoComment.run(item: task, user: user, message: 'completed')
          expect(outcome.result.body).to eq('Generic User completed this task on January 01, 2016.')
        end
      end
      it 'creates a comment using the lale-bot user' do
        outcome = Comment::AutoComment.run(item: task, user: user, message: 'completed')
        expect(outcome.result.commenter.name).to eq('Lale Bot')
      end

    end
  end

  context 'for supplies' do
    let(:supply) { create(:supply) }

    context '#execute' do
      it 'creates a comment' do
        outcome = Comment::AutoComment.run(item: supply, user: user, message: 'completed')
        expect(outcome).to be_success
      end
      it 'fills the comment body with an internationalized message' do
        Timecop.freeze(Time.parse("2016-01-01")) do
          outcome = Comment::AutoComment.run(item: supply, user: user, message: 'completed')
          expect(outcome.result.body).to eq('Generic User completed this supply on January 01, 2016.')
        end
      end
      it 'creates a comment using the lale-bot user' do
        outcome = Comment::AutoComment.run(item: supply, user: user, message: 'completed')
        expect(outcome.result.commenter.name).to eq('Lale Bot')
      end

    end


  end

end
