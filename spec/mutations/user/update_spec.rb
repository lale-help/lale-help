require 'rails_helper'

describe User::Update do
  let(:defaults) do
    {
      first_name: "foo",
      last_name: "bar",
      email: "baz@bing.com",
      password: "Password1",
      password_confirmation: "Password1",
      language: 0,
      accept_terms: true
    }
  end

  context '#validate' do
    context 'email' do
      it "fails if invalid format" do
        outcome = User::Create.new(email: 'foo@bar').submit
        expect(outcome).to have_mutation_error(:email, :matches)
      end

      it "fails on empty" do
        outcome = User::Create.new(email: '').submit
        expect(outcome).to have_mutation_error(:email, :empty)
      end

      it "fails on nil" do
        outcome = User::Create.new(email: nil).submit
        expect(outcome).to have_mutation_error(:email, :empty)
      end
    end

    context 'password' do
      it "fails on nil" do
        outcome = User::Create.new(password: nil).submit
        expect(outcome).to have_mutation_error(:password, :nils)
      end

      it "must be confirmed" do
        bad_password = "password"

        outcome = User::Create.new(defaults, password_confirmation: bad_password).submit
        expect(outcome).to have_mutation_error(:password, :does_not_match)
      end

      it "must have an integer" do
        password = "Foobarbaz"
        outcome = User::Create.new(defaults, password: password, password_confirmation: password).submit
        expect(outcome).to have_mutation_error(:password, :no_numeric)
      end

      it "must have a capital letter" do
        password = "foobarbaz1"
        outcome = User::Create.new(defaults, password: password, password_confirmation: password).submit
        expect(outcome).to have_mutation_error(:password, :no_upper)
      end

      it "must be 8 characters long" do
        password = "Fooooo1"
        outcome = User::Create.new(defaults, password: password, password_confirmation: password).submit
        expect(outcome).to have_mutation_error(:password, :too_short)
      end

      it "passes" do
        outcome = User::Create.new(defaults).submit
        expect(outcome).to be_success
      end
    end
  end
end