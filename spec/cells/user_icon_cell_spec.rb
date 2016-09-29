require 'rails_helper'

RSpec.describe UserIconCell, type: :cell do

  include RSpecHtmlMatchers

  context 'cell rendering' do

    let(:circle) { create(:circle, :with_admin) }
    let(:user)   { circle.admin }

    context "without options" do
      let(:html) { cell(:user_icon, user, circle: circle).call }

      it "renders as expected" do
        expect(html).to have_tag('.user-icon-container .user-icon .text', text: user.initials)
      end

    end
  end

end
