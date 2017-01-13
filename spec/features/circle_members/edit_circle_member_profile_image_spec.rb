require 'rails_helper'

describe "Edit a circle member profile image", js: true do

  let(:circle)      { create(:circle, :with_admin_and_working_group, volunteer: user) }
  let(:member_form) { PageObject::Member::Form.new }

  before { member_form.load(circle_id: circle.id, id: user.id, as: user.id) }

  describe "Adding a profile picture" do
    let(:user)   { create(:user) }
    let(:inputs) { { profile_image: Rails.root.join('spec/fixtures/images/avatar.jpg') } }
    it "works" do
      member_page = member_form.submit_with(inputs)
      expect(member_page).to have_flash('Your settings have been saved.')
      expect(member_page).to have_profile_image
    end
  end

  describe "Removing the profile picture" do
    let!(:user)   { create(:user, :with_profile_image) }
    let(:inputs)  { { remove_profile_image: true } }
    context "user has a profile photo" do
      it "works" do
        member_page = member_form.submit_with(inputs)
        expect(member_page).to have_flash('Your settings have been saved.')
        expect(member_page).not_to have_profile_image
      end
    end
  end

end