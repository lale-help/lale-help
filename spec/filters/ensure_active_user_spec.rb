require 'rails_helper'

describe "EnsureActiveUser filter" do
  
  context "user is logged out" do
    it "doesn't redirect" do
      controller = double('Controller', current_user: nil)
      expect(controller).not_to receive(:redirect_to)
      EnsureActiveUser.before(controller)
    end
  end

  context "user is logged in" do
    
    context "user is not pending" do
      it "doesn't redirect" do
        user       = double('User', pending?: false)
        controller = double('Controller', current_user: user)
        expect(controller).not_to receive(:redirect_to)
        EnsureActiveUser.before(controller)
      end
    end

    context "user is pending" do

      context "user doesn't have a circle, yet" do
        it "redirects" do
          user       = double('User', pending?: true, has_circles?: false)
          controller = double('Controller', current_user: user)
          expect(controller).not_to receive(:redirect_to)
          EnsureActiveUser.before(controller)
        end
      end

      context "user has a circle" do
        context "user isn't on pending info page" do
          it "redirects" do
            user       = double('User', pending?: true, has_circles?: true, primary_circle: 42)
            controller = double('Controller', current_user: user)
            allow(controller).to receive(:membership_pending_public_circle_path)
            allow(EnsureActiveUser).to receive(:on_pending_member_page?) { false }
            expect(controller).to receive(:redirect_to)
            EnsureActiveUser.before(controller)
          end
        end

        context "user is on pending info page" do
          it "doesn't redirect" do
            user       = double('User', pending?: true, has_circles?: true)
            controller = double('Controller', current_user: user)
            allow(controller).to receive(:membership_pending_public_circle_path)
            allow(EnsureActiveUser).to receive(:on_pending_member_page?) { true }
            expect(controller).not_to receive(:redirect_to)
            EnsureActiveUser.before(controller)
          end
        end
      end
    end
  end
end