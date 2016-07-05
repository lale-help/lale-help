require 'rails_helper'

describe "Supply", type: :feature, js: true do
  
  let(:circle) { create(:circle) }

  let!(:circle_admin_role)      { create :circle_role_admin, circle: circle }

  let(:user_1) { create(:user, primary_circle: circle) } #Admin
  let(:user_2) { create(:user, primary_circle: circle) } #Volunteer

  let(:public_group)  { create(:working_group, is_private: false, circle: circle) }
  let(:private_group) { create(:working_group, is_private: true , circle: circle) }

  let(:t_supply) { t("activerecord.models.supply.one") }

  def create_supply(supply)
    base = "activerecord.attributes.supply"
    fill_in t("#{base}.name"),         with: supply.name
    fill_in t("#{base}.description"),  with: supply.description
    fill_in t("#{base}.due_date"),     with: supply.due_date                      
    fill_in t("#{base}.location"),     with: supply.location
    
    click_button  t("helpers.submit.create", model: t_supply)
    supply
  end

  def visit_add_supply(user)
    visit(circle_path(circle, as: user))
    find('.button-super', text: /#{t("sidebar.circle_add_menu.add")}/).click
    click_on t_supply
  end

  before do
    create(:circle_role_admin, circle: circle, user: user_1) 
    create(:circle_role_volunteer, circle: circle, user: user_2)

    public_group.roles.member.create              user: user_1
    public_group.roles.member.create              user: user_2

    private_group.roles.member.create             user: user_1
  end

  context 'add supply button' do
    let(:add_text) { t("sidebar.circle_add_menu.add") }

    it 'is visible to Admin' do
      visit(circle_path(circle, as: user_1))
      
      expect(find('.button-super', text: /#{add_text}/)).to_not eq(nil)
      find('.button-super', text: /#{add_text}/).click
      expect(page).to have_link(t_supply)
    end

    it 'not visible to Volunteer' do
      visit(circle_path(circle, as: user_2))
      expect(page).to_not have_selector('.button-super', text: /#{add_text}/)
    end
  end

  context 'an admin' do
    it "adds a supply" do
      visit_add_supply(user_1)
      s = create_supply(FactoryGirl.create(:supply))

      expect(page).to have_content(t("flash.actions.create.notice", resource_name: t_supply))
      expect(page).to have_content(s.name)
      expect(page).to have_content(s.description)

      expect(page).to have_content("#{t("activerecord.attributes.supply.due_date")} #{s.due_date.strftime("%A %-d %B %Y")}")
      expect(page).to have_content(s.location)
    end

    it "edits a supply" do
      visit_add_supply(user_1)
      s = create_supply(FactoryGirl.create(:supply))
      find('.button-super', text: /#{t("helpers.edit", model: t_supply)}/).click
      click_on  t("circle.supplies.edit_actions.edit_button_dropdown")
      s.name =  "Edited #{s.name}"
      fill_in   t("activerecord.attributes.supply.name"), with: s.name
  
      click_on  t("helpers.submit.update", model: t_supply)
      expect(page).to have_content t("flash.updated", name: t_supply)
      expect(page).to have_content s.name
    end

    it "has a supply" do
      visit_add_supply(user_1)
      s = create_supply(FactoryGirl.create(:supply))

      click_on  t("helpers.volunteer", model: t_supply)
      expect(page).to have_content t("helpers.decline", model: t_supply)
      expect(page).to have_content(t("suppliers.auto_comment.user_assigned", 
                                     user: user_1.name, 
                                     date: s.due_date.strftime("%B %-d, %Y")))
    end

    it "completes a supply" do
      visit_add_supply(user_1)
      s = create_supply(FactoryGirl.create(:supply))

      find('.button-super', text: /#{t("helpers.edit", model: t_supply)}/).click
      click_on  t("helpers.complete", model: t_supply)

      expect(page).to have_content(t("supplies.auto_comment.completed", 
                                     user: user_1.name, 
                                     date: s.due_date.strftime("%B %-d, %Y")))
      expect(page).to have_content  t("circle.show.users_box_title")
      expect(page).to have_link     circle_member_path(circle, user_1)
    end
  end

  context 'add supply page' do
    it 'requires a Name, Description, Due Date, and Location' do
      visit_add_supply(user_1)
      fill_in       t("activerecord.attributes.supply.due_date"), with: nil
      click_button  t("helpers.submit.create", model: t_supply)

      expect(page).to have_content t("errors.name.empty")
      expect(page).to have_content t("errors.due_date.empty")
      expect(page).to have_content t("errors.description.empty")
      expect(page).to have_content t("errors.location.empty")
    end
  end
end