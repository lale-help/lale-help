require 'rails_helper'

describe "Edit a circle member profile", js: true do

  let(:circle)        { create(:circle, :with_admin_and_working_group, :with_volunteer) }
  let(:working_group) { circle.working_groups.first }

  let(:member_form) { PageObject::Member::Form.new }

  let(:inputs) { { first_name: 'Emil', last_name: 'Emu' } }

  context "when user is circle admin" do
    
    let(:current_user) { circle.admin }

    context "when editing own profile" do

      let(:user) { current_user }
      before { member_form.load(id: user.id, as: current_user.id) }

      it "works" do
        member_page = member_form.submit_with(inputs)
        expect(member_page).to have_content('Emil Emu')
        expect(member_page).to have_flash('Your settings have been saved.')
      end
    end

    context "when editing other member's profile" do

      let(:user) { circle.volunteers.first }
      before { member_form.load(id: user.id, as: current_user.id) }

      it "works" do
        member_page = member_form.submit_with(inputs)
        expect(member_page).to have_content('Emil Emu')
        expect(member_page).to have_flash('Your settings have been saved.')
      end
    end
  end

  context "when user is circle member" do

    let(:current_user) { circle.volunteers.first }

    context "when editing own profile" do
      
      let(:user) { current_user }
      before { member_form.load(id: user.id, as: current_user.id) }

      it "works" do
        member_page = member_form.submit_with(inputs)
        expect(member_page).to have_content('Emil Emu')
        expect(member_page).to have_flash('Your settings have been saved.')
      end
    end

    context "when editing other member's profile" do

      let(:user) { circle.admin }
      before { member_form.load(id: user.id, as: current_user.id) }
      let(:member_page) { PageObject::Member::Page.new }

      it "is not possible" do
        expect(member_page).to have_flash('Not authorized to edit user')
      end
    end
  end

end