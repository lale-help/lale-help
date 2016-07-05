require 'rails_helper'

describe "Supply", type: :feature, js: true do

  let(:circle) { create(:circle) }

  let!(:circle_admin_role)      { create :circle_role_admin, circle: circle }

  let(:user_1) { create(:user, primary_circle: circle) } #Admin
  let(:user_2) { create(:user, primary_circle: circle) } #Volunteer

  let(:public_group)  { create(:working_group, is_private: false, circle: circle) }
  let(:private_group) { create(:working_group, is_private: true , circle: circle) }

  def create_supply(supply)
    fill_in "Name of supply",                   with: supply.name
    fill_in "Description",                      with: supply.description
    fill_in "Due Date",                         with: supply.due_date                      
    fill_in "Location",                         with: supply.location
    
    click_button  "Create Supply"
    supply
  end

  def visit_add_supply(user)
    visit(circle_path(circle, as: user))
    find('.button-super', text: /Add/).click
    click_on('Supply')
  end

  before do
    create(:circle_role_admin, circle: circle, user: user_1) 
    create(:circle_role_volunteer, circle: circle, user: user_2)

    public_group.roles.member.create              user: user_1
    public_group.roles.member.create              user: user_2

    private_group.roles.member.create             user: user_1
  end

  context 'add supply button' do
    it 'is visible to Admin' do
      visit(circle_path(circle, as: user_1))
      
      expect(find('.button-super', text: /Add/)).to_not eq(nil)
      find('.button-super', text: /Add/).click
      expect(page).to have_link('Supply')
    end

    it 'not visible to Volunteer' do
      visit(circle_path(circle, as: user_2))
      expect(page).to_not have_selector('.button-super', text: /Add/)
    end
  end

  context 'an admin' do
    it "adds a supply" do
      visit_add_supply(user_1)
      s = create_supply(FactoryGirl.create(:supply))

      expect(page).to have_content("Supply was successfully created.")
      expect(page).to have_content(s.name)
      expect(page).to have_content(s.description)

      expect(page).to have_content("Due Date #{s.due_date.strftime("%A %-d %B %Y")}")
      expect(page).to have_content(s.location)
    end

    it "edits a supply" do
      visit_add_supply(user_1)
      s = create_supply(FactoryGirl.create(:supply))
      find('.button-super', text: /Edit Supply/).click
      click_on("Edit Supply")
      fill_in "Name of supply", with: "Edited #{s.name}"
  
      click_on  "Update Supply"
      expect(page).to have_content("Supply was successfully updated.")
      expect(page).to have_content("Edited #{s.name}")
    end
  end

  context 'add supply page' do
    it 'requires a Name, Description, Due Date, and Location' do
      visit_add_supply(user_1)
      fill_in "Due Date", with: nil
      click_button  "Create Supply"

      expect(page).to have_content(t("errors.name.empty"))
      expect(page).to have_content(t("errors.due_date.empty"))
      expect(page).to have_content(t("errors.description.empty"))
      expect(page).to have_content(t("errors.location.empty"))
    end
  end
end