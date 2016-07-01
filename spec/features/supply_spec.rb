require 'rails_helper'

describe "supply", type: :feature, js: true do

  let(:circle) { create(:circle) }

  let!(:circle_admin_role)      { create :circle_role_admin, circle: circle }

  let(:user_1) { create(:user, primary_circle: circle) } #Admin
  let(:user_2) { create(:user, primary_circle: circle) } #Volunteer

  let(:public_group)  { create(:working_group, is_private: false, circle: circle) }
  let(:private_group) { create(:working_group, is_private: true , circle: circle) }

  def create_supply(name, description, due_date, location)
    date = I18n.l(due_date) if due_date != nil
    fill_in "Name of supply",                   with: name
    fill_in "Description",                      with: description
    fill_in "Due Date",                         with: date                      
    fill_in "Location",                         with: location
    
    click_button  "Create Supply"
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
    it 'visible to Admin' do
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
      name        = "Test Supply"
      description = "Test Description"
      due_date    = Date.today
      location    = "Oakland, CA 94607, USA"

      visit_add_supply(user_1)
      create_supply(name, description, due_date, location)

      expect(page).to have_content("Supply was successfully created.")
      expect(page).to have_content(name)
      expect(page).to have_content(description)
      puts "Formatted: #{due_date.strftime("%A %-d %B %Y")}"
      expect(page).to have_content("Due Date #{due_date.strftime("%A %-d %B %Y")}")
      expect(page).to have_content(location)
    end

    it "edits a supply" do
      name        = "Test Supply"
      description = "Test Description"
      due_date    = Date.today
      location    = "Oakland, CA 94607, USA"

      visit_add_supply(user_1)
      create_supply(name, description, due_date, location)
      find('.button-super', text: /Edit Supply/).click
      click_on("Edit Supply")
      fill_in "Name of supply", with: "Edited #{name}"
  
      click_on  "Update Supply"
      expect(page).to have_content("Supply was successfully updated.")
      expect(page).to have_content("Edited #{name}")
    end
  end

  context 'add supply page' do

    it 'requires a Name, Description, Due Date, and Location' do
      visit_add_supply(user_1)

      create_supply(nil, nil, nil, nil)

      expect(page).to have_content(t("errors.name.empty"))
      expect(page).to have_content(t("errors.due_date.empty"))
      expect(page).to have_content(t("errors.description.empty"))
      expect(page).to have_content(t("errors.location.empty"))
    end
  end
end