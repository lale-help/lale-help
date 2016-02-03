require 'rails_helper'

describe TokenHandlers::ResetPassword do
  subject { TokenHandlers::ResetPassword }
  let(:volunteer)      { create(:volunteer)  }
  let(:token)          { create(:reset_password_token, user: volunteer) }

  let(:controller) do
    double(:controller).tap do |c|
      allow(c).to receive(:redirect_to)
      allow(c).to receive(:login).with(volunteer)
      allow(c).to receive(:current_user)
    end
  end

  it 'logs in the user and take them to the reset password form' do
    outcome = subject.run(token: token, controller: controller)

    token.reload

    expect(outcome.success?).to be(true)
    expect(token.active).to be(false)
    expect(controller).to have_received(:login).with(volunteer)
    expect(controller).to have_received(:redirect_to).with(account_reset_password_path)
  end
end