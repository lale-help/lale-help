require 'rails_helper'

describe "Supply", type: :feature, js: true do
  
  let(:circle) { create(:circle) }

  let!(:circle_admin_role)      { create :circle_role_admin, circle: circle }

  let(:user_1) { create(:user, primary_circle: circle) } #Admin
  let(:user_2) { create(:user, primary_circle: circle) } #Volunteer
  let(:user_3) { create(:user, primary_circle: circle) } #Volunteer
  let(:user_4) { create(:user, primary_circle: circle) } #Volunteer

  let(:public_group)  { create(:working_group, is_private: false, circle: circle) }
  let(:private_group) { create(:working_group, is_private: true , circle: circle) }

  before do
    create(:circle_role_admin,     circle: circle, user: user_1) 
    create(:circle_role_volunteer, circle: circle, user: user_2)
    create(:circle_role_volunteer, circle: circle, user: user_3)
    create(:circle_role_volunteer, circle: circle, user: user_4)

    public_group.roles.member.create              user: user_1
    public_group.roles.member.create              user: user_2
    public_group.roles.member.create              user: user_3

    private_group.roles.member.create             user: user_1
  end

  context 'add page' do
    let(:supply) { FactoryGirl.create(:supply) }
    let(:sp)     { sp = SupplyPage.new(supply) }

    it 'is visible to Admin' do
      visit(circle_path(circle, as: user_1))
      
      expect(sp.addable?).to eq(true)
      expect(sp.create).to_not eq(nil)
    end

    it 'not visible to Volunteer' do
      visit(circle_path(circle, as: user_2))
      expect(sp.addable?).to eq(false)
    end

    it 'requires a Name, Description, Due Date, and Location' do
      visit(circle_path(circle, as: user_1))
      supply.name = nil
      supply.due_date = nil
      supply.location = nil
      supply.description = nil
      sp.create()

      expect(page).to have_content "Name can't be empty"
      expect(page).to have_content "Please enter a due date"
      expect(page).to have_content "Please enter a description"
      expect(page).to have_content "Please enter a location"
    end
  end

  context 'an admin' do
    it "adds a supply" do
      sp = SupplyPage.new(FactoryGirl.create(:supply))
      visit(circle_path(circle, as: user_1))
      s = sp.create

      expect(page).to have_content "Supply was successfully created."
      expect(page).to have_content s.name
      expect(page).to have_content s.description

      expect(page).to have_content "Due Date #{s.due_date.strftime("%A %-d %B %Y")}"
      expect(page).to have_content s.location
    end

    it "edits a supply" do
      sp = SupplyPage.new(FactoryGirl.create(:supply))
      visit(circle_path(circle, as: user_1))
      s = sp.create
      expect(sp.editable?).to eq(true)
      s.name =  "Edited #{s.name}"
      sp.edit

      expect(page).to have_content "Supply was successfully updated"
      expect(page).to have_content s.name
    end

    it "has a supply" do
      sp = SupplyPage.new(FactoryGirl.create(:supply))
      visit(circle_path(circle, as: user_1))
      sp.create
      sp.has_supply

      expect(page).to have_content "I don't have this Supply"
      expect(page).to have_content "#{user_1.name} signed up for this supply on #{I18n.l(Date.today, format: :long)}"
    end

    it "completes a supply" do
      sp = SupplyPage.new(FactoryGirl.create(:supply))
      visit(circle_path(circle, as: user_1))
      sp.create
      sp.complete
      
      expect(page).to have_content "#{user_1.name} completed this supply on #{I18n.l(Date.today, format: :long)}"
    end

    it "invites circle to a supply" do
      s  = FactoryGirl.create(:supply)
      sp = SupplyPage.new(s)
      visit(circle_path(circle, as: user_1))
      sp.create

      expect(sp.invite_circle_visible?).to eq(true)
      sp.invite_circle
      count = circle.users.size - 2 # Not sure why size = 5
      expect(page).to have_content "#{user_1.name} invited #{count} helpers to this supply on #{I18n.l(Date.today, format: :long)}"
    end

    it "invites working group to a supply" do
      s  = FactoryGirl.create(:supply)
      sp = SupplyPage.new(s)
      visit(circle_path(circle, as: user_1))
      sp.create

      expect(sp.invite_wg_visible?).to eq(true)
      sp.invite_wg
      count = public_group.users.size - 1
      expect(page).to have_content "#{user_1.name} invited #{count} helpers to this supply on #{I18n.l(Date.today, format: :long)}"
    end
  end

  context 'a volunteer' do
    let(:supply) { FactoryGirl.create(:supply) }
    let(:sp)     { sp = SupplyPage.new(supply) }

    it 'cannot edit a supply' do
      visit(circle_path(circle, as: user_1))
      sp.create

      visit(circle_supply_path(circle, supply, as: user_2))
      expect(sp.editable?).to eq(false)
    end

    it 'cannot invite circle' do
      visit(circle_path(circle, as: user_1))
      sp.create

      visit(circle_supply_path(circle, supply, as: user_2))
      expect(sp.invite_circle_visible?).to eq(false)
    end

    it 'cannot invite working group' do
      visit(circle_path(circle, as: user_1))
      sp.create

      visit(circle_supply_path(circle, supply, as: user_2))
      expect(sp.invite_wg_visible?).to eq(false)
    end
  end
end