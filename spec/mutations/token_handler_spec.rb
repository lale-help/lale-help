require 'rails_helper'


describe TokenHandler do
  subject { TokenHandler }

  let(:controller) do
    double(:controller).tap do |c|
      allow(c).to receive(:redirect_to)
      allow(c).to receive(:login)
      allow(c).to receive(:current_user)
    end
  end

  context "with an active token" do
    let(:token) { create(:token) }

    it 'can handle a token' do
      outcome = subject.handle(token.code, controller)

      token.reload

      expect(outcome.success?).to be(true)
      expect(outcome.result).to be(true)
      expect(token.active).to be(false)
    end
  end

  context "with an inactive token" do
    let(:token) { create(:token, active: false) }

    it 'can handle a token' do
      outcome = subject.handle(token.code, controller)

      token.reload

      expect(outcome.success?).to be(false)
      expect(outcome.result).to be(nil)
      expect(outcome.errors.symbolic[:token]).to be_present
      expect(token.active).to be(false)
    end
  end

  context "with an unknown token handler" do
    let(:token) do
      create(:token).tap do |t|
        allow_any_instance_of(Token).to receive(:token_type).and_return("foobar")
      end
    end

    it 'can handle a token' do
      outcome = subject.handle(token.code, controller)

      token.reload

      expect(outcome.success?).to be(false)
      expect(outcome.result).to be(nil)
      expect(outcome.errors.symbolic[:handler]).to be_present
      expect(token.active).to be(true)
    end
  end
end