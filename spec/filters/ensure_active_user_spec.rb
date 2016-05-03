require 'rails_helper'

describe "EnsureActiveUser filter" do
  
  let(:current_circle) { double('Circle') }
  let(:current_user) { double('User') }
  let(:controller) { double('Controller', current_user: current_user, current_circle: current_circle) }

  context "when no current_user is available" do
    let(:current_user) { nil }

    it "doesn't redirect" do
      expect(controller).not_to receive(:redirect_to)
      EnsureActiveUser.before(controller)
    end
  end

  context "when no current_circle is available" do
    let(:current_circle) { nil }

    it "doesn't redirect" do
      expect(controller).not_to receive(:redirect_to)
      EnsureActiveUser.before(controller)
    end
  end

  context "when current_user is available" do
    
    context "when user is in one circle" do

      context "when user is active" do
        before { allow(current_circle).to receive(:has_active_user?) { true } }

        it "doesn't redirect" do
          expect(controller).not_to receive(:redirect_to)
          EnsureActiveUser.before(controller)
        end
      end

      context "when user is pending" do

        before { allow(current_circle).to receive(:has_active_user?) { false } }
        # stub the method; not relevant for test setup
        before { allow(controller).to receive(:membership_pending_public_circle_path) }

        context "when user isn't on pending info page" do
          it "redirects" do
            allow(EnsureActiveUser).to receive(:on_pending_member_page?) { false }
            expect(controller).to receive(:redirect_to)
            EnsureActiveUser.before(controller)
          end
        end

        context "when user is on pending info page" do
          it "doesn't redirect" do
            allow(EnsureActiveUser).to receive(:on_pending_member_page?) { true }
            expect(controller).not_to receive(:redirect_to)
            EnsureActiveUser.before(controller)
          end
        end
      end
    end

  end
end