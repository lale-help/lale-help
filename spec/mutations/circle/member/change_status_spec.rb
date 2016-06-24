require 'rails_helper'

describe Circle::Member::Comments::StatusChange do
  let(:user) { create(:user, first_name: 'Generic', last_name: 'User') }
  let(:circle) { create(:circle) }
  let(:member) { create(:user, first_name: 'John', last_name: 'Doe') }

  context '#execute' do
    it 'creates a comment' do
      outcome = Circle::Member::Comments::StatusChange.run(item: member, user: user, circle: circle, status: :activated)
      expect(outcome).to be_success
    end
    it 'fills the comment body with an internationalized message' do
      Timecop.freeze(Time.parse("2016-01-01")) do
        outcome = Circle::Member::Comments::StatusChange.run(item: member, user: user, circle: circle, status: :blocked)
        expect(outcome.result.body).to eq('John Doe blocked on January 01, 2016 by Generic User.')
      end
    end
    it 'creates a comment using the lale-bot user' do
      outcome = Circle::Member::Comments::StatusChange.run(item: member, user: user, circle: circle, status: :unblocked)
      expect(outcome.result.commenter.name).to eq('Lale Bot')
    end

  end
end
