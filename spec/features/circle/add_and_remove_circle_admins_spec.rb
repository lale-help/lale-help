require 'rails_helper'

describe "Add and remove circle admins", js: true do
  
  let(:circle)        { create(:circle, :with_admin) }
  let(:admin)         { circle.admin }

  let(:roles_page) { PageObject::Circle::Roles.new }  

  describe "add" do
  
    context "circle has a member that's not admin yet" do

      let!(:circle_member) { create(:circle_member_role, circle: circle).user }

      before { roles_page.load(circle_id: circle.id, as: admin.id) }
      
      it "can be added" do
        roles_page.promote_user_link.click
        # circle_member is selected in the dropdown already, no selecting necessary.
        roles_page.save_role_button.click
        expect(roles_page).to have_admin(circle_member)
      end
    end
  end

  describe "remove" do

    context "circle has a member that's not admin yet" do

      let!(:circle_admin) { create(:circle_admin_role, circle: circle).user }

      before { roles_page.load(circle_id: circle.id, as: admin.id) }

      it "can be removed" do
        expect(roles_page).to have_admin(circle_admin)
        roles_page.admins[1].remove_button.click
        expect(roles_page).not_to have_admin(circle_admin)
      end
    end
  end

end
