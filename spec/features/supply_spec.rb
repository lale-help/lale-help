require 'rails_helper'

describe "#new", type: :feature, js: true do

  let(:circle) { create(:circle) }

  let!(:circle_admin_role)      { create :circle_role_admin, circle: circle }
  #let!(:circle_organizer_role)  { create :circle_role_organizer, circle: circle }

  let(:user_1) { create(:user, primary_circle: circle) } #Admin
  let(:user_2) { create(:user, primary_circle: circle) } #Organizer
  let(:user_3) { create(:user, primary_circle: circle) } #Volunteer

  let(:public_group)  { create(:working_group, is_private: false, circle: circle) }
  let(:private_group) { create(:working_group, is_private: true , circle: circle) }

  def fill_in_supply(name, description, due_date, location)
    date = I18n.l(due_date) if due_date != nil
    fill_in "Name of supply",                   with: name
    fill_in "Description",                      with: description
    fill_in "Due Date",                         with: date                      
    fill_in "Location",                         with: location
    
    click_button  "Create Supply"
  end

  def visit_add_supply(user)
    visit(circle_path(circle, as: user))
    find('.button-primary', text: /Add/).click
    click_on('Supply')
  end

  before do
    circle.roles.send('circle.admin').create      user: user_1
    #circle.roles.send('circle.organizer').create  user: user_2
    circle.roles.send('circle.volunteer').create  user: user_3

    public_group.roles.member.create              user: user_1
    public_group.roles.member.create              user: user_2
    public_group.roles.member.create              user: user_3

    private_group.roles.member.create             user: user_1
    private_group.roles.member.create             user: user_2
  end

  context 'add supply button' do
    it 'visible to Admin' do
      visit(circle_path(circle, as: user_1))
      
      expect(find('.button-primary', text: /Add/)).to_not eq(nil)
      find('.button-primary', text: /Add/).click
      expect(page).to have_link('Supply')
    end

    # it 'visible to Organizer' do
    #   visit(circle_path(circle, as: user_2))
    #   expect(page).to have_link('Supply')
    # end

    it 'not visible to Volunteer' do
      visit(circle_path(circle, as: user_3))
      expect(page).to_not have_selector('.button-primary', text: /Add/)
    end
  end

  context 'an admin' do

    context 'with circle' do
      it "adds a supply" do
        name        = "Test Supply"
        description = "Test Description"
        due_date    = Date.today
        location    = "Oakland, CA 94607, USA"

        visit_add_supply(user_1)
        fill_in_supply(name, description, due_date, location)

        expect(page).to have_content("Supply was successfully created.")
        expect(page).to have_content(name)
        expect(page).to have_content(description)
        expect(page).to have_content(due_date.strftime("%A %d %B %Y"))
        expect(page).to have_content(location)
      end

      it "edits a supply" do
        name        = "Test Supply"
        description = "Test Description"
        due_date    = Date.today
        location    = "Oakland, CA 94607, USA"

        visit_add_supply(user_1)
        fill_in_supply(name, description, due_date, location)
        click_on("Edit Supply")
        page.save_screenshot('edit_supply.jpg')

        fill_in "Name of supply", with: "Edited #{name}"
        click_button  "Update Supply"
        expect(page).to have_content("Supply was successfully updated.")
        expect(page).to have_content("Edited #{name}")
      end
    end
  end

  context 'add supply page' do

    it 'requires a supply name' do
      visit_add_supply(user_1)

      name        = nil
      description = "Test Description"
      due_date    = Date.today
      location    = "Oakland, CA 94607, USA"
      fill_in_supply(name, description, due_date, location)
      click_on('Supply')
      expect(page).to have_content("Name can't be empty")
    end

    it 'requires a description' do
      visit_add_supply(user_1)

      name        = "Test Supply"
      description = nil
      due_date    = Date.today
      location    = "Oakland, CA 94607, USA"
      fill_in_supply(name, description, due_date, location)
      click_on('Supply')
      expect(page).to have_content("Description can't be empty")
    end

    it 'requires a due date' do
      visit_add_supply(user_1)

      name        = "Test Supply"
      description = "Test Description"
      due_date    = nil
      location    = "Oakland, CA 94607, USA"
      fill_in_supply(name, description, due_date, location)
      click_on('Supply')
      page.save_screenshot('duedate_error_supply.jpg')
      expect(page).to have_content("Due Date can't be empty")
    end

    it 'requires a location' do
      visit_add_supply(user_1)

      name        = "Test Supply"
      description = "Test Description"
      due_date    = Date.today
      location    = nil
      fill_in_supply(name, description, due_date, location)
      click_on('Supply')
      page.save_screenshot('location_error_supply.jpg')
      expect(page).to have_content("Location can't be empty")
    end

    it 'requires a due date ge today' do
      visit_add_supply(user_1)

      name        = "Test Supply"
      description = "Test Description"
      due_date    = (Date.today - 1)
      location    = "Oakland, CA 94607, USA"
      fill_in_supply(name, description, due_date, location)
      page.save_screenshot('duedate_ge_error_supply.jpg')
      expect(page).to have_content("Due Date can't be empty")
    end
  end
end