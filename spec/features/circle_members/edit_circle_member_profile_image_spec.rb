require 'rails_helper'

describe "Edit a circle member profile image", js: true do

  let(:volunteer)     { create(:user) }
  let(:circle)        { create(:circle, :with_admin_and_working_group, volunteer: volunteer) }
  let(:admin)         { circle.admin }
  let(:working_group) { circle.working_groups.first }

  let(:member_form) { PageObject::Member::Form.new }

  let(:inputs) { { profile_image: Rails.root.join('spec/fixtures/images/avatar.jpg') } }

  let(:current_user) { volunteer }
  before { member_form.load(circle_id: circle.id, id: current_user.id, as: current_user.id) }

  describe "Adding a profile picture" do
    it "works" do
      member_page = member_form.submit_with(inputs)
      expect(member_page).to have_flash('Your settings have been saved.')
      expect(member_page).to have_a_profile_image
    end
  end

  # describe "Removing the profile picture" do
  #   context "user has a profile photo" do
  #     it "works" do
  #       member_page = member_form.submit_with(inputs)
  #       # expect(member_page.headline.text).to eq('Emil Emu')
  #       expect(member_page).to have_flash('Your settings have been saved.')
  #       show!
  #     end
  #   end
  # end

end